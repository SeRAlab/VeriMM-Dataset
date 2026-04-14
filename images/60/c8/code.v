module binary_counter(
	input clk,
	input reset,
	output reg [3:0] count,
	output max);assign max = (count == 4'b1111);

always @(posedge clk) begin
    if (reset)
        count <= 4'b0000;
    else
        count <= count + 1;
end
endmodule