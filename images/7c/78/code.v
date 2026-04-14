module top_module(
    input clk,
    input load,
    input clear,
    input serial_in,
    input [7:0] data_in,
    output reg [7:0] q);always @(posedge clk) begin
		if (clear)
			q <= 8'b00000000;
		else if (load)
			q <= data_in;
		else
			q <= {q[6:0], serial_in};
	end
endmodule