module top_module(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, S, T, U, V, Y);input A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, S, T, U, V; 
 output Y; 
 assign Y = V ? U ? T ? (S ? P : O) : 
  (S ? N : M) : 
  T ? (S ? L : K) : 
  (S ? J : I) : 
  U ? T ? (S ? H : G) : 
  (S ? F : E) : 
  T ? (S ? D : C) : 
  (S ? B : A); 
 endmodule