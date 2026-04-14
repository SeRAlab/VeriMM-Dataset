module top_module(
	input wire clk,
    input wire ce,
	input wire [9:0] a1,
    input wire [9:0] a2,
	input wire [7:0] din,
	output reg [7:0] dout1,
    output reg [7:0] dout2,
	input wire we
	);reg [7:0] mem[0:1023];
    always @(posedge clk) begin
        dout2 <= mem[a2];
        dout1 <= mem[a1];
        if (we == 1'b1 && ce == 1'b1)
            mem[a1] <= din;
    end
endmodule