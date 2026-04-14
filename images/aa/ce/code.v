module top_module(A, B, Cin, CK, S, Cout);input [3:0] A;
input [3:0] B;
input Cin;
input CK;
output [3:0] S;
output Cout;

reg [3:0] S;
reg Cout;

always @(posedge CK) begin
    S <= A + B + Cin;
    Cout <= (S[4] == 1) ? 1 : 0;
end

endmodule