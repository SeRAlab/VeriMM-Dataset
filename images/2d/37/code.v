module pipeline_adder (
    input wire clk,
    input wire [7:0] A,
    input wire [7:0] B,
    input wire [7:0] C,
    output reg [8:0] result
);
    reg [8:0] sum_stage1;

    always @(posedge clk) begin
        sum_stage1 <= A + B; // Stage 1: Sum A and B
    end

    always @(posedge clk) begin
        result <= sum_stage1 + C; // Stage 2: Add constant C
    end
endmodule