module pipelined_adder (
    input wire clk,
    input wire reset,
    input wire [4:0] A,
    input wire [4:0] B,
    output reg [5:0] S
);
    reg [5:0] sum_stage1;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            sum_stage1 <= 6'b0;
            S <= 6'b0;
        end else begin
            sum_stage1 <= A + B; // First stage
            S <= sum_stage1;     // Second stage
        end
    end
endmodule