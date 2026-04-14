module top_module(A1, A2, A3, A4, O);input   A1;
input   A2;
input   A3;
input   A4;
output  O;

wire    M1;
wire    M2;
wire    M3;
wire    N1;
wire    N2;

// Implement majority gate using standard gates
assign M1 = A1 & A2;
assign M2 = A2 & A3;
assign M3 = A1 & A3;
assign N1 = ~(M1 | M2);
assign N2 = ~(M1 | M3);
assign O = ~(N1 | N2 | (A1 & A2 & A3 & A4));

endmodule