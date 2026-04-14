module pipelined_multiplier (
    input clk,
    input [3:0] a, // 4-bit input a
    input [3:0] b, // 4-bit input b
    output reg [7:0] result // 8-bit output result
);
    reg [7:0] product_stage1;

    // Stage 1: Compute the product
    always @(posedge clk) begin
        product_stage1 <= a * b; // Multiply inputs
    end

    // Stage 2: Output the product
    always @(posedge clk) begin
        result <= product_stage1; // Pass intermediate product to output
    end
endmodule