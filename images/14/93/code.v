module pipelined_adder (
    input clk,
    input [3:0] A,
    input [3:0] B,
    output reg [4:0] sum_out,
    output reg carry_out
);
    reg [3:0] stage1_sum;
    
    always @(posedge clk) begin
        // Stage 1: Compute sum
        stage1_sum <= A + B;
    end
    
    always @(posedge clk) begin
        // Stage 2: Output sum and carry
        sum_out <= {1'b0, stage1_sum}; // 5-bit output
        carry_out <= (A + B) > 4'b1111; // Carry out logic
    end
endmodule