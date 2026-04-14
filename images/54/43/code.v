module gray_counter(
	input clk,
	input reset,
	output reg [3:0] gray_code);reg [3:0] binary_count;

always @(posedge clk or posedge reset) begin
    if (reset)
        binary_count <= 4'b0000;
    else
        binary_count <= binary_count + 1;
end

always @(*) begin
    gray_code = binary_count ^ (binary_count >> 1);
end
endmodule