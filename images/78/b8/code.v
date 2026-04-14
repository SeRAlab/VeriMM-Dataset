module up_down_counter(
	input clk,
	input reset,
	input up,
	input down,
	output reg [2:0] count);always @(posedge clk) begin
    if (reset)
        count <= 3'b000;
    else if (up && !down)
        count <= count + 1;
    else if (!up && down)
        count <= count - 1;
end
endmodule