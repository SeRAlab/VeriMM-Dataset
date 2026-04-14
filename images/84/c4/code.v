module top_module(
    input [3:0] binary_in,
    input clk,
    output reg [3:0] gray_out
);always @(posedge clk) begin
    gray_out[3] = binary_in[3];
    gray_out[2] = binary_in[3] ^ binary_in[2];
    gray_out[1] = binary_in[2] ^ binary_in[1];
    gray_out[0] = binary_in[1] ^ binary_in[0];
end

endmodule