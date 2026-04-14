module top_module(
    input [1:0] A, B,
    input clk,          // Added clk as an input
    output reg [3:0] P, // Changed output P to reg type
    output reg CARRY     // Changed output CARRY to reg type
);reg [1:0] a_reg, b_reg;
reg [3:0] p_reg;
reg carry_reg;

always @(posedge clk) begin
    a_reg <= A;
    b_reg <= B;
end

always @(posedge clk) begin
    p_reg <= {2'b0, a_reg[0] & b_reg[0]};
    carry_reg <= a_reg[0] & b_reg[0];
end

always @(posedge clk) begin
    p_reg <= p_reg + {1'b0, a_reg[1] & b_reg[0], a_reg[0] & b_reg[1]};
    carry_reg <= carry_reg | (a_reg[1] & b_reg[0]) | (a_reg[0] & b_reg[1]);
end

always @(posedge clk) begin
    p_reg <= p_reg + {1'b0, 1'b0, a_reg[1] & b_reg[1]};
    P <= p_reg;       // Assigning the value to reg type
    CARRY <= carry_reg; // Assigning the value to reg type
end

endmodule