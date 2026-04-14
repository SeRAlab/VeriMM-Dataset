module top_module(test_clk,D3,D2,D1,D0,wire_1718,CON_BUS1,CON_BUS0,CE0,A0,A1,A2,clkb_1777,clkb_bus_1777,RESETB,rst_res_n,VIMDS1,VIMDS0);input  test_clk;   
   output D3,D2,D1,D0;
   input  wire_1718;
   input  CON_BUS1;
   input  CON_BUS0;
   output CE0;
   output A0,A1,A2;
   input  clkb_1777;
   input [2:0] clkb_bus_1777;
   input 	   RESETB;
   input 	   rst_res_n;
   output 	   VIMDS1,VIMDS0;
   
   
   
   assign D3 = test_clk;
   assign D2 = wire_1718;
   assign D1 = CON_BUS1;
   assign D0 = CON_BUS0;
   assign CE0 = wire_1718;
   assign A0 = wire_1718;
   assign A1 = wire_1718;
   assign A2 = clkb_1777 & ^clkb_bus_1777 & RESETB & rst_res_n;
   assign VIMDS1 = rst_res_n;
   assign VIMDS0 = rst_res_n;endmodule