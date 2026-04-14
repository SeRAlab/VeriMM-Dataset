module counter_4bit(
	input clk,
	input reset,
	input ena,
	output reg [3:0] count);always @(posedge clk) begin
    if (reset)
        count <= 4'b0000;
    else if (ena)
        count <= count + 1;
end
endmodule