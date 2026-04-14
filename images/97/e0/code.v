module top_module(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    input Clk,
    output [3:0] S,
    output Cout,
    output Overflow,
    output Ready
);reg [3:0] S_reg;
    reg Cout_reg;
    reg Overflow_reg;
    reg Ready_reg;

    always @(posedge Clk) begin
        if (Ready_reg) begin
            S_reg <= A + B + Cin;
            Cout_reg <= (A[3] & B[3]) | (A[3] & Cin) | (B[3] & Cin);
            Overflow_reg <= ((A[3] & B[3] & ~Cin) | (~A[3] & ~B[3] & Cin)) ? 1'b1 : 1'b0;
            Ready_reg <= 1'b0;
        end else begin
            Ready_reg <= 1'b1;
        end
    end

    assign S = S_reg;
    assign Cout = Cout_reg;
    assign Overflow = Overflow_reg;
    assign Ready = Ready_reg;

endmodule