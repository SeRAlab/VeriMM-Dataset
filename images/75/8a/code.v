module top_module(
    input clk,
    output reg [3:0] gray_out
);reg [3:0] binary_out;
reg [3:0] gray_prev;

always @(posedge clk) begin
    binary_out <= binary_out + 1;
    gray_out <= binary_out ^ (binary_out >> 1);
    if (binary_out == 4'b1111) begin
        binary_out <= 4'b0000;
    end
end

endmodule