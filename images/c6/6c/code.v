module binary_to_gray(
    input [3:0] binary_in,
    input clk,
    output reg [3:0] gray_out
);

reg [3:0] binary_prev;

always @(posedge clk) begin
    binary_prev <= binary_in;
    gray_out <= binary_in ^ (binary_in >> 1);
end

endmodule