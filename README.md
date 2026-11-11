# tutorial-netfpga: packet processing in hardware on the NetFPGA

Hands-on material for learning to write packet-processing modules in Verilog on the
[NetFPGA](https://netfpga.org/) 1G platform (NF 2.1). It starts from the platform's tutorial router
project and adds two user modules to the data path: one that drops every nth packet, and one that
timestamps packets in hardware to estimate the bottleneck of a network path.

The material dates from 2015. A longer written introduction to the platform, in Portuguese, is the
short-course chapter *NetFPGA: Processamento de Pacotes em Hardware* (Goulart, Cunha, Vieira,
Marcondes and Menotti, Minicursos do SBRC 2015).

## The two modules

**`drop_nth_packet`** (`working/drop_nth_packet.v`, registers in `drop_nth_packet.xml`). The
classic first exercise: a module in the user data path that counts packets and drops one in every
*n*. It shows the pieces every NetFPGA module needs: the input FIFO, the state machine that walks
the packet word by word, and software-visible registers to enable the module and set *n*.

**`estimation`** (`src/estimation.v`, registers in `include/estimation.xml`, earlier versions in
`working/`). A module that inspects each packet as it passes, selects IP packets, and records
hardware timestamps of selected packets in eight registers (`timestamp1` to `timestamp8`) that
software reads back. Timestamping in the data path, and not in the host, is what makes it possible to
measure packet spacing precisely enough to estimate the bottleneck capacity of a path. The three
files in `working/` are successive versions and show how the state machine grew.

Both are wired into `src/user_data_path.v`, next to the reference pipeline's rate limiter.

## Layout

| Path | Contents |
|---|---|
| `src/` | `estimation.v` and the modified `user_data_path.v` |
| `working/` | `drop_nth_packet.v`, three iterations of `estimation.v` and an earlier register module (`bottleneck_reg_old.v`) |
| `include/` | Project definition and register maps (`project.xml`, `estimation.xml`, generated `registers.v`) |
| `lib/C`, `lib/Perl5` | Generated register definitions for software |
| `sw/` | Host-side tools in C and Perl: read registers (`readregister.c`), control and receive the event-capture system (`monitor_ctrl.c`, `rcv_evts.c`), router GUIs, and an `iperf` traffic script |
| `synth/` | Synthesis makefile and constraints for the NetFPGA 1G board |
| `verif/test_rate_limiter/` | Simulation test: packet generator script, configuration and waveform setup |
| `regress/` | Regression tests run on the board |

## Building

The project is meant to be placed under `projects/` in a NetFPGA 1G (NF 2.1) source tree, which
provides the reference modules it includes. From there, `make` in `synth/` produces the bitfile and
`make` in `sw/` builds the host tools. The board, the Xilinx ISE toolchain of that generation and the
NetFPGA base package are required; none of them is part of this repository.

## Provenance

The project builds on the NetFPGA tutorial router, and files that carry a NetFPGA header keep their
original terms. The `drop_nth_packet` and `estimation` modules, the register maps for them and the
changes to the data path are the tutorial's own work.
