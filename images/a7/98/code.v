module mux_4to1 (
    input wire A,
    input wire B,
    input wire C,
    input wire D,
    input wire Sel0,
    input wire Sel1,
    output wire Y
    );

assign Y = (Sel1 ? (Sel0 ? D : C) : (Sel0 ? B : A));

endmodule