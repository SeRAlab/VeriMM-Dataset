module pipeline_2stage (
    input clk,
    input [3:0] a,
    input [3:0] b,
    input [3:0] constant,
    output reg [3:0] stage1_out,
    output reg [3:0] stage2_out
);
    
    // Stage 1: Addition
    always @(posedge clk) begin
        stage1_out <= a + b;
    end
    
    // Stage 2: Subtraction
    always @(posedge clk) begin
        stage2_out <= stage1_out - constant;
    end
endmodule