module pipelined_adder_multiplier (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] result
);
    reg [7:0] add_result;
    reg [15:0] mul_result;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            add_result <= 8'b0;
            mul_result <= 16'b0;
            result <= 16'b0;
        end else begin
            // Stage 1: Addition
            add_result <= a + b;

            // Stage 2: Multiplication
            mul_result <= add_result * 8'h2; // Multiply by 2 for testing
            result <= mul_result;
        end
    end
endmodule