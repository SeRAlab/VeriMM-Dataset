module pipelined_adder (
    input wire clk,
    input wire [4:0] A,
    input wire [4:0] B,
    output reg [5:0] SUM
);
    reg [5:0] stage1_sum;

    // Stage 1: Calculate sum
    always @(posedge clk) begin
        stage1_sum <= A + B;
    end

    // Stage 2: Output the result
    always @(posedge clk) begin
        SUM <= stage1_sum;
    end
endmodule