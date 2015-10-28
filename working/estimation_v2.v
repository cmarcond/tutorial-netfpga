///////////////////////////////////////////////////////////////////////////////
// $Id: estimation 2008-03-13 gac1 $
//
// Module: estimation.v
// Project: NF2.1
// Description: defines a module that drops the nth packet
// 
///////////////////////////////////////////////////////////////////////////////
`timescale 1ns/1ps
`include "NF_2.1_defines.v"

  module estimation
  #(parameter DATA_WIDTH = 64,
    parameter CTRL_WIDTH = 8,
    parameter UDP_REG_SRC_WIDTH = 3,
    parameter SW_REGS_TAG = 4,
    parameter CNTR_REGS_TAG = 5,
    parameter PROT_IP = 1)
   (
    input  [DATA_WIDTH-1:0]              in_data,
    input  [CTRL_WIDTH-1:0]              in_ctrl,
    input                                in_wr,
    output                               in_rdy,

    output [DATA_WIDTH-1:0]              out_data,
    output [CTRL_WIDTH-1:0]              out_ctrl,
    output                               out_wr,
    input                                out_rdy,
    
    // --- Register interface
    input                                reg_req_in,
    input                                reg_ack_in,
    input                                reg_rd_wr_L_in,
    input  [`UDP_REG_ADDR_WIDTH-1:0]     reg_addr_in,
    input  [`CPCI_NF2_DATA_WIDTH-1:0]    reg_data_in,
    input  [UDP_REG_SRC_WIDTH-1:0]       reg_src_in,

    output                               reg_req_out,
    output                               reg_ack_out,
    output                               reg_rd_wr_L_out,
    output  [`UDP_REG_ADDR_WIDTH-1:0]    reg_addr_out,
    output  [`CPCI_NF2_DATA_WIDTH-1:0]   reg_data_out,
    output  [UDP_REG_SRC_WIDTH-1:0]      reg_src_out,
 
    // misc
    input                                reset,
    input                                clk);

   function integer log2;
      input integer number;
      begin
         log2=0;
         while(2**log2<number) begin
            log2=log2+1;
         end
      end
   endfunction // log2

  //------------------------- Internal paremeters -------------------------------

  parameter IDLE 			= 'h0;
  parameter MOD_HDR 			= 'h1;
  parameter PROTOCOL_HDR 		= 'h2;
  parameter PROT_IP_CHECK_S 		= 'h3;
  parameter DST_IP_ADDR_CHECK_S		= 'h4;
  parameter WAIT_END_PKT		= 'h5;

  parameter NUM_STATES 			= 6;

  reg [NUM_STATES-1:0] 			state;
  reg [NUM_STATES-1:0] 			next_state;

  wire [DATA_WIDTH-1:0]			in_fifo_data;
  wire [CTRL_WIDTH-1:0]			in_fifo_ctrl;

  wire [31:0]				key;
  wire 					in_fifo_nearly_full;
  wire 					in_fifo_empty;

  reg 					in_fifo_rd_en;
  reg 					in_fifo_rd_en_2;
  reg 					out_wr_int;				
  reg [DATA_WIDTH-1:0]			out_data_int;

  // Signal to reset counters 
  reg 					rst_pktcounter;
  reg 					rst_pktslice;

  // Signal incrementaly update counters 
  reg 					inc_pktslice;
  reg 					inc_pktcounter;
  reg 					inc_clkcounter;
  
  // Counters for packets slices, full packet counters, clock timestamping
  reg [15:0] 				pktslice;
  reg [15:0] 				pktcounter;
  reg [15:0] 				clkcounter;

  // Our stuff
  reg [31:0]				pick_packet0_reg;
  reg [31:0]				pick_packet1_reg;
  reg [31:0]				pick_packet2_reg;
  reg [31:0]				pick_packet3_reg;
  reg [31:0]				pick_packet4_reg;
  reg [31:0]				pick_packet5_reg;
  reg [31:0]				pick_packet6_reg;
  reg [31:0]				pick_packet7_reg;

  reg [31:0] 				mask;
  reg [31:0]				extracted_field;

  assign   	in_rdy = !in_fifo_nearly_full && out_rdy;
  assign 	out_wr = out_wr_int;
//  assign 	out_data = in_fifo_data;
  assign 	out_data = out_data_int;
  assign 	out_ctrl = in_fifo_ctrl;

  //------------------------- Modules-------------------------------

  small_fifo #(.WIDTH(CTRL_WIDTH+DATA_WIDTH), .MAX_DEPTH_BITS(5), .PROG_FULL_THRESHOLD(31))
    input_fifo
      (.din           ({in_ctrl, in_data}),  // Data in
       .wr_en         (in_wr),             // Write enable
       .rd_en         (in_fifo_rd_en),    // Read the next word 
       .dout          ({in_fifo_ctrl, in_fifo_data}),
       .full          (),
       .nearly_full   (in_fifo_nearly_full),
       .empty         (in_fifo_empty),
       .reset         (reset),
       .clk           (clk)
       );

   generic_regs
   #(
      .UDP_REG_SRC_WIDTH   (UDP_REG_SRC_WIDTH),
      .TAG                 (`ESTIMATION_BLOCK_ADDR),                 // Tag -- eg. MODULE_TAG
      .REG_ADDR_WIDTH      (`ESTIMATION_REG_ADDR_WIDTH),                 // Width of block addresses -- eg. MODULE_REG_ADDR_WIDTH
      .NUM_COUNTERS        (0),                 // Number of counters
      .NUM_SOFTWARE_REGS   (1),                 // Number of sw regs
      .NUM_HARDWARE_REGS   (8)                  // Number of hw regs
   ) module_regs (
      .reg_req_in       (reg_req_in),
      .reg_ack_in       (reg_ack_in),
      .reg_rd_wr_L_in   (reg_rd_wr_L_in),
      .reg_addr_in      (reg_addr_in),
      .reg_data_in      (reg_data_in),
      .reg_src_in       (reg_src_in),

      .reg_req_out      (reg_req_out),
      .reg_ack_out      (reg_ack_out),
      .reg_rd_wr_L_out  (reg_rd_wr_L_out),
      .reg_addr_out     (reg_addr_out),
      .reg_data_out     (reg_data_out),
      .reg_src_out      (reg_src_out),

      // --- counters interface
      .counter_updates  (),
      .counter_decrement(),

      // --- SW regs interface
      .software_regs    (key),

      // --- HW regs interface
      .hardware_regs    ({pick_packet7_reg,
        pick_packet6_reg,
        pick_packet5_reg,
        pick_packet4_reg,
        pick_packet3_reg,
        pick_packet2_reg,
        pick_packet1_reg,
        pick_packet0_reg}),

      .clk              (clk),
      .reset            (reset)
    );

  //------------------------- Logic-------------------------------

   //latch the state
   always @(posedge clk) begin
      if(reset) begin
         state <= IDLE;
      end
      else begin
         state <= next_state;
      end
   end 

  //--- State Machine
  always @(*) begin
    //default assignments
    
    next_state <= state;
    out_wr_int <= 0;
    in_fifo_rd_en <= 0;
    out_data_int <= in_fifo_data;

    case(state)
      IDLE: begin                               // state 0
        if (!in_fifo_empty && out_rdy) begin
             out_wr_int <= 1;
             in_fifo_rd_en <= 1;

          if (in_fifo_ctrl == 'hff) begin
	     next_state <= MOD_HDR;
             rst_pktslice <= 1; 
          end
	  else begin
	     rst_pktslice <= 1;
          end
        end
      end

      MOD_HDR: begin                            // state 1
        if (!in_fifo_empty && out_rdy) begin
           out_wr_int <= 1;
           in_fifo_rd_en <= 1;

           if (in_fifo_ctrl == 0) begin
              rst_pktslice <= 0;
	      inc_pktslice <= 1;
              next_state <= PROTOCOL_HDR;
           end
        end
      end

      PROTOCOL_HDR: begin                            // state 2
        if (!in_fifo_empty && out_rdy) begin
          out_wr_int <= 1;
          in_fifo_rd_en <= 1;
          inc_pktslice <= 1;

	    if (in_fifo_ctrl == 0) begin
            	if (pktslice == PROT_IP) begin  // supposed to be pktslice = 2
                	next_state <= PROT_IP_CHECK_S;
	    	end
	    end
        end
     end

      PROT_IP_CHECK_S: begin                          // state 3
        if (!in_fifo_empty && out_rdy) begin
          out_wr_int <= 1;
          in_fifo_rd_en <= 1;

           if (in_fifo_ctrl == 0) begin
		extracted_field = {24'b0, in_fifo_data[7:0]}; 
		if (extracted_field == 'h0) begin // later on synthesis PUT A 06 HERE !!!
			next_state <= WAIT_END_PKT; // DST_IP_ADDR_CHECK_S;
			inc_pktslice <= 1; // supposed to go to pktslice = 3	
		end 
		else begin
			rst_pktslice <= 0; 
			next_state <= IDLE;
		end
           end

        end
      end
/*
      DST_IP_ADDR_CHECK_S: begin                          // state 3
        if (!in_fifo_empty && out_rdy) begin
          out_wr_int <= 1;
          in_fifo_rd_en <= 1;

           if (in_fifo_ctrl == 0) begin
                if (pktslice == PROT_IP + 1) begin  // supposed to be pktslice = 4
                	extracted_field = {40'b0, in_fifo_data[23:0]};	
			inc_pktslice <= 1;
		end
		if (pktslice == PROT_IP + 2) begin
			mask <= {extracted_field[23:0], in_fifo_data[63:55]};
			extracted_field <= mask; // got finally the poor destination IP address
			if (extracted_field == key) begin
				next_state <= WAIT_END_PKT;
			end
			else begin 
				rst_pktslice <= 0;
				next_state <= IDLE;
			end
		end
                next_state <= IDLE;
           end

        end
      end
*/
      WAIT_END_PKT: begin
	if (!in_fifo_empty && out_rdy) begin
          out_wr_int <= 1;
	  in_fifo_rd_en <= 1;	  
	end
	
	if (in_fifo_ctrl != 0 && in_fifo_ctrl != 'hff) begin 
          next_state <= IDLE;
	  inc_pktcounter <= 1;
	end

      end

    endcase
  end

  // Obtain Timestamps
  // of the arrivals of packets and store in hardware regs
  always @(posedge clk) begin
    if (reset) begin
       pick_packet0_reg <= 'h0;
       pick_packet1_reg <= 'h0;
       pick_packet2_reg <= 'h0;
       pick_packet3_reg <= 'h0;
       pick_packet4_reg <= 'h0;
       pick_packet5_reg <= 'h0;
       pick_packet6_reg <= 'h0;
       pick_packet7_reg <= 'h0;
    end
    else begin
       if (inc_pktcounter) begin

	case (pktcounter)
	'h1: begin pick_packet0_reg <= clkcounter; end 
	'h2: begin pick_packet1_reg <= clkcounter; end 
	'h3: begin pick_packet2_reg <= clkcounter; end 
	'h4: begin pick_packet3_reg <= clkcounter; end 
	'h7: begin pick_packet4_reg <= clkcounter; end 
	'h8: begin pick_packet5_reg <= clkcounter; end 
	'h15: begin pick_packet6_reg <= clkcounter; end 
	'h16: begin 
		pick_packet7_reg <= clkcounter;
		rst_pktcounter <= 0; 
	end 
        endcase
	end // if inc_pktcounter
    end  // else ! reset
  end

  // Packet Slice (a fraction of 64 bits of a packet)
  always @(posedge clk) begin
    if (reset) begin
      pktslice <= 0;
    end
    else begin
      //insert counter code
       if(rst_pktslice) begin
          pktslice <= 0;
       end
       else if (inc_pktslice) begin
       pktslice <= pktslice + 1;
       end
    end
  end

  // Packet Counter
  always @(posedge clk) begin
    if (reset) begin
      pktcounter <= 0;
    end
    else begin
      //insert pktcounter code
       if(rst_pktcounter) begin
	  pktcounter <= 0;
       end
       else if (inc_pktcounter) begin
       pktcounter <= pktcounter + 1;
       end 
    end
  end
  
  // Clock Counter
  always @(posedge clk) begin
    if (reset) begin
      clkcounter <= 0;
    end
    else begin
      //always increase clkcounter
       clkcounter <= clkcounter + 1;
    end
  end

endmodule 
