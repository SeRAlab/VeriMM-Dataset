module top_module (
	input clk,
	input areset,
	input a,
	input b,
	output [7:0] product);reg [7:0] product;
reg [3:0] counter;
always @(posedge clk or posedge areset) begin
	if (areset) begin
		product <= 8'b0;
		counter <= 4'b0;
	end else begin
		if (a && b)
			product <= product + (a << counter);
		counter <= counter + 1;
	end
end

endmodule