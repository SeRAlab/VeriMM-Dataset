module top_module(input [3:0] A, B, input Cin, clk, output [3:0] S, output Cout);reg [3:0] S_reg;
    reg Cout_reg;

    always @(posedge clk) begin
        S_reg <= A + B + Cin;
        Cout_reg <= (A[3] & B[3]) | (A[3] & Cin) | (B[3] & Cin);
    end

    assign S = S_reg;
    assign Cout = Cout_reg;

endmodule