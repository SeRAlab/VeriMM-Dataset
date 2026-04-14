module pipelined_multiplier (
    input clk,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] result
);
    reg [15:0] mul_result; // Intermediate result of multiplication

    always @(posedge clk) begin
        // First stage: multiply the inputs
        mul_result <= a * b;
    end

    always @(posedge clk) begin
        // Second stage: add constant
        result <= mul_result + 5;
    end
endmodule