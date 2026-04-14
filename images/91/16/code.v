module shift_register #(
	parameter N = 8
)(
	input clk,
	input rst,
	input load,
	input [N-1:0] data_in,
	input shift_in,
	output reg [N-1:0] data_out
);

always @(posedge clk or posedge rst) begin
	if (rst) begin
		data_out <= {N{1'b0}};
	end else if (load) begin
		data_out <= data_in;
	end else begin
		data_out <= {data_out[N-2:0], shift_in};
	end
end

endmodule