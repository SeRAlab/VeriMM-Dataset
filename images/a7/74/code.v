module top_module(A, B, C, D, Sel, Out);input A, B, C, D;
input [1:0] Sel;
output Out;







assign Out = (Sel[1] && Sel[0]) ? D : ((Sel[1] && !Sel[0]) ? C : ((!Sel[1] && Sel[0]) ? B : A));


endmodule