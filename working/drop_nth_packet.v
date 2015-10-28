///////////////////////////////////////////////////////////////////////////////
// $Id: drop_nth_packet 2008-03-13 gac1 $
//
// Module: drop_nth_packet.v
// Project: NF2.1
// Description: defines a module that drops the nth packet
// 
///////////////////////////////////////////////////////////////////////////////
`timescale 1ns/1ps
`include "NF_2.1_defines.v"

  module drop_nth_packet
  #(parameter DATA_WIDTH = 64,
    parameter CTRL_WIDTH = 8,
    parameter UDP_REG_SRC_WIDTH = 3,
    parameter SW_REGS_TAG = 4,
    parameter CNTR_REGS_TAG = 5)
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
  parameter WAIT_END_PKT 		= 'h1;

  parameter NUM_STATES 			= 2;

  reg [NUM_STATES-1:0] 			state;
  reg [NUM_STATES-1:0] 			next_state;

  wire [DATA_WIDTH-1:0]			in_fifo_data;
  wire [CTRL_WIDTH-1:0]			in_fifo_ctrl;

  wire 					in_fifo_nearly_full;
  wire 					in_fifo_empty;

  reg 					in_fifo_rd_en;
  reg 					in_fifo_rd_en_2;
  reg 					out_wr_int;				

  wire [`CPCI_NF2_DATA_WIDTH-1:0] 	drop_nth_packet_en_reg;
  wire [`CPCI_NF2_DATA_WIDTH-1:0] 	drop_nth_packet_reg; //software register

  reg [`CPCI_NF2_DATA_WIDTH-1:0] 	drop_nth_packet_en_reg_prev;  
  reg [`CPCI_NF2_DATA_WIDTH-1:0] 	drop_nth_packet_reg_prev;

  wire [15:0] 				drop_nth_packet;

  wire 					rst_counter;
  reg 					rst_pktcounter;
  reg 					inc_counter;
  reg 					inc_pktcounter;
  reg [15:0] 				counter;
  reg [15:0] 				pktcounter;
  reg [15:0] 				clkcounter;
 
  reg 					rst_counter_state;
  reg 					rst_counter_reg;


  // Our stuff
  reg [31:0]				pick_packet0_reg;
  reg [31:0]				pick_packet1_reg;
  reg [31:0]				pick_packet2_reg;
  reg [31:0]				pick_packet3_reg;
  reg [31:0]				pick_packet4_reg;
  reg [31:0]				pick_packet5_reg;
  reg [31:0]				pick_packet6_reg;
  reg [31:0]				pick_packet7_reg;

  
  assign   	in_rdy = !in_fifo_nearly_full && out_rdy;
  assign 	out_wr = out_wr_int;
  assign 	out_data = in_fifo_data;
  assign 	out_ctrl = in_fifo_ctrl;
  assign 	drop_nth_packet = 'h3;
  assign 	rst_counter = rst_counter_state || rst_counter_reg;

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

/*  generic_regs
    #(
    .UDP_REG_SRC_WIDTH 	(UDP_REG_SRC_WIDTH),
    .TAG 	       	(`DROP_NTH_BLOCK_ADDR), 
    .REG_ADDR_WIDTH    	(`DROP_NTH_REG_ADDR_WIDTH),
    .NUM_REGS_USED 	(10))
    bottleneck_regs
    (
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

    .hardware_regs     ({pick_packet0_reg,
    	pick_packet1_reg,
    	pick_packet2_reg,
    	pick_packet3_reg,
    	pick_packet4_reg,
    	pick_packet5_reg,
    	pick_packet6_reg,
    	pick_packet7_reg}),

    .clk (clk),
    .reset (reset));
*/

   generic_regs
   #(
      .UDP_REG_SRC_WIDTH   (UDP_REG_SRC_WIDTH),
      .TAG                 (`DROP_NTH_BLOCK_ADDR),                 // Tag -- eg. MODULE_TAG
      .REG_ADDR_WIDTH      (`DROP_NTH_REG_ADDR_WIDTH),                 // Width of block addresses -- eg. MODULE_REG_ADDR_WIDTH
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
	drop_nth_packet_reg_prev <= 0;
	drop_nth_packet_en_reg_prev <= 0;
      end
      else begin
         state <= next_state;
	drop_nth_packet_reg_prev <= drop_nth_packet_reg;
	drop_nth_packet_en_reg_prev <= drop_nth_packet_en_reg;
      end
   end 

  //--- State Machine
  always @(*) begin
    //default assignments
    next_state    = state;

    //out_wr_int = 0;
    in_fifo_rd_en = 0;
    inc_pktcounter = 0;

    case(state)
      IDLE: begin
	if (!in_fifo_empty && out_rdy) begin
	  in_fifo_rd_en = 1;

	  if (in_fifo_ctrl == 0) begin
	    next_state = WAIT_END_PKT;
	  end
	end
      end

      WAIT_END_PKT: begin
	if (!in_fifo_empty && out_rdy) begin
	  in_fifo_rd_en = 1;	  
	end
	
	if (in_fifo_ctrl != 0 && in_fifo_ctrl != 'hff) begin 
          next_state = IDLE;
	  inc_pktcounter = 1;
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
	'h5: begin pick_packet4_reg <= clkcounter; end 
	'h6: begin pick_packet5_reg <= clkcounter; end 
	'h7: begin pick_packet6_reg <= clkcounter; end 
	'h8: begin 
		pick_packet7_reg <= clkcounter;
		rst_pktcounter <= 0; 
	end 
        endcase
	end // if inc_pktcounter
    end  // else ! reset
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
