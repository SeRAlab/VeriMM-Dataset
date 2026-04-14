module top_module(
    input clk,
    input [3:0] A,
    input [3:0] B,
    input mode,
    output reg [3:0] out
);always @(posedge clk) begin
    if (mode == 1'b1) // Addition
        out <= A + B;
    else // Subtraction
        out <= A - B;
end

endmodule