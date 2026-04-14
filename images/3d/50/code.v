module pipelined_adder (
    input wire clk,
    input wire [7:0] a,
    input wire [7:0] b,
    output reg [7:0] sum
);
    reg [7:0] a_reg, b_reg;

    always @(posedge clk) begin
        a_reg <= a;       // Stage 1: Register inputs
        b_reg <= b;       // Stage 1: Register inputs
        sum <= a_reg + b_reg; // Stage 2: Compute sum
    end
endmodule