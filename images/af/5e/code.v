module top_module(
    input clk,
    input rst,
    input  [15:0] in,
    output [15:0] out,

    input enable
);reg [15:0]dff[3:1];
  
  
  wire [15:0]mul_c3 = in *  3'd3;
  wire [15:0]mul_c2 = in * -5'sd10;
  wire [15:0]mul_c1 = in *  4'd4;
  wire [15:0]mul_c0 = in * -6'sd17;
  
  
  wire [15:0]add0 = dff[1] + mul_c0;
  wire [15:0]add1 = dff[2] + mul_c1;
  wire [15:0]add2 = dff[3] + mul_c2;
  assign out = add0;
  
  
  always @(posedge clk or posedge rst)
      if (rst == 1'b1)
	  {dff[1], dff[2], dff[3]} <= 'h0;
      else if (enable == 1'b1)
	  {dff[1], dff[2], dff[3]} <= {add1, add2, mul_c3};


endmodule