module top_module(
    input [2:0] A,
    input [1:0] B,
    input C,
    input D,
    input E,
    input F,
    input G,
    input H,
    input I,
    output J
);wire is_111 = (A == 3'b111);
    wire is_000 = (A == 3'b000);
    wire is_other = !is_111 && !is_000;

    assign J = (is_111) ? 1 :
               (is_000) ? 0 :
               ((B == 2'b00) && (C == 1'b1) && (D == 1'b0) && (E == 1'b1) && (F == 1'b0) && (G == 1'b1) && (H == 1'b0) && (I == 1'b1)) ? 1 :
               0;

endmodule