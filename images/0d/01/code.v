module pipelined_adder(
    input [3:0] A,
    input [3:0] B,
    input clk,
    output reg [4:0] result
);
    reg [4:0] stage1_result;
    
    always @(posedge clk) begin
        // Stage 1: Add A and B
        stage1_result <= A + B;
    end

    always @(posedge clk) begin
        // Stage 2: Add the constant 3 to the result of stage 1
        result <= stage1_result + 3;
    end
endmodule