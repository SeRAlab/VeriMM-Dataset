module shift_reg_4bit(
	input wire [3:0] D,
	input wire clk,
	input wire rst,
	input wire load,
	output reg [3:0] Q
);

always @(posedge clk or posedge rst) begin
	if (rst) begin
		Q <= 4'b0000;
	end else if (load) begin
		Q <= D;
	end else begin
		Q <= {Q[2:0], 1'b0};
	end
end

endmodule