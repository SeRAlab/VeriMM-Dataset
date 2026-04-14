module top_module(A, B, Cin, S, Cout);input [3:0] A;
    input [3:0] B;
    input Cin;
    output [3:0] S;
    output Cout;
    
    reg [3:0] S_reg;
    reg Cout_reg;
    
    always @ (A or B or Cin) begin
        S_reg = A + B + Cin;
        Cout_reg = (A[3] & B[3]) | (A[3] & Cin) | (B[3] & Cin);
    end
    
    assign S = S_reg;
    assign Cout = Cout_reg;
    
endmodule