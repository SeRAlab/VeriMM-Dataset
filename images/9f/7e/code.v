module top_module(
    input  wire clk,

    input  wire rx,
    output wire tx,

	input  wire [15:0] sw,
	output wire [15:0] led
);assign led = sw;

  
  assign tx = rx;
endmodule