module top_module(
   clk,
   rst,
   
   slave_addr,
   slave_wdat,
   slave_wstb,
   slave_rdat,

   master_type,
   master_port,
   master_addr,
   master_wdat,
   master_tstb,
   master_trdy,
   
   master_rstb,
   master_rdat

   );input           clk;
   input 	   rst;
   input [7:0] 	   slave_addr;
   input [15:0]    slave_wdat;
   input 	   slave_wstb;
   output [15:0]   slave_rdat;
   output [3:0]    master_type;
   output [3:0]    master_port;
   output [7:0]    master_addr;
   output [15:0]   master_wdat;
   output 	   master_tstb;
   input 	   master_trdy;
   input 	   master_rstb;
   input [15:0]    master_rdat;

   wire [7:0] 	   slave_addr_i;
   wire [15:0] 	   slave_wdat_i;
   wire 	   slave_wstb_i;
   wire 	   master_trdy_i;
   wire 	   master_rstb_i;
   wire [15:0] 	   master_rdat_i;
   
   assign #1 	   slave_addr_i = slave_addr;
   assign #1 	   slave_wdat_i = slave_wdat;
   assign #1 	   slave_wstb_i = slave_wstb;
   assign #1 	   master_trdy_i = master_trdy;
   assign #1 	   master_rstb_i = master_rstb;
   assign #1 	   master_rdat_i = master_rdat;
   
   reg [15:0] 	   slave_rdat_o;
   reg [3:0] 	   master_type_o;
   reg [3:0] 	   master_port_o;
   reg [7:0] 	   master_addr_o;
   reg [15:0] 	   master_wdat_o;
   reg 		   master_tstb_o;

   assign #1 	   slave_rdat = slave_rdat_o;
   assign #1 	   master_type = master_type_o;
   assign #1 	   master_port = master_port_o;
   assign #1 	   master_addr = master_addr_o;
   assign #1 	   master_wdat = master_wdat_o;
   assign #1 	   master_tstb = master_tstb_o;

   

endmodule