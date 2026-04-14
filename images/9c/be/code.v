module top_module(
    input [7:0] switch0,
    input [7:0] switch1,
    input [7:0] switch2,
    input [7:0] switch3,
    input [7:0] switch4,
    input [7:0] switch5,
    input [7:0] switch6,
    input [7:0] switch7,
	 input [7:0] userkey,
    input [7:0] Address,
    output [31:0] DataOut
    );wire [31:0] S1;
	 wire [31:0] S2;
	 wire [31:0] S3;
	 
	 assign S1 = {switch3,switch2,switch1,switch0};
	 assign S2 = {switch7,switch6,switch5,switch4};
	 assign S3 = {24'b0,~userkey};
	 
	 assign DataOut = (Address == 8'h2c) ? S1 : 
							(Address == 8'h30) ? S2 : 
										  S3;

endmodule