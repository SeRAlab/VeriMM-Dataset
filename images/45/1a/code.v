module top_module(A, B, C, D, E, F, G, H, S, T, U, Y);input A, B, C, D, E, F, G, H, S, T, U;
output Y;
assign Y = U ? T ? (S ? H : G) :
                   (S ? F : E) :
               T ? (S ? D : C) :
                   (S ? B : A);
endmodule