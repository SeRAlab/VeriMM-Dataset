module pipelined_adder (
    input clk,
    input rst,
    input [7:0] A,
    input [7:0] B,
    output reg [7:0] S
);
    reg [7:0] stage1_result;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            stage1_result <= 0;
            S <= 0;
        end else begin
            stage1_result <= A + B;  // Stage 1: Add A and B
            S <= stage1_result + 5;  // Stage 2: Add result with 5
        end
    end
endmodule