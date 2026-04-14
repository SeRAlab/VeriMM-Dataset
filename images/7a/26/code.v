module counter_4bit_load(
	input wire clk,
	input wire load,
	input wire [3:0] data,
	input wire rst,
	output reg [3:0] count
);

always @(posedge clk or posedge rst) begin
	if (rst) begin
		count <= 4'b0000;
	end else if (load) begin
		count <= data;
	end else begin
		count <= count + 1;
	end
end

endmodule