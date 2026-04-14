module top_module(
    input clk,
    output reg [3:0] gray_out
);reg [3:0] binary_out;

initial begin
    binary_out = 0;
    gray_out = 0;
end

always @(posedge clk) begin
    binary_out <= binary_out + 1;
    gray_out <= binary_out ^ (binary_out >> 1);
end

endmodule