module top_module(
    input [15:0] A,
    input [15:0] B,
    input [3:0] S,
    input clk,               // Added clk input
    output reg [15:0] Y
);reg [15:0] A_reg, B_reg, Y_reg;
reg [3:0] S_reg;

always @(posedge clk) begin
    A_reg <= A;
    B_reg <= B;
    S_reg <= S;
end

always @(posedge clk) begin
    case(S_reg)
        4'b0000: Y_reg <= A_reg;
        4'b1111: Y_reg <= B_reg;
        default: Y_reg <= (S_reg < 4'b1111) ? 
                          (S_reg[3] ? B_reg >> (S_reg[2:0]) : A_reg << (S_reg[2:0])) : Y_reg; // Fixed shifting logic
    endcase
end

always @(posedge clk) begin
    Y <= Y_reg;
end

endmodule