module mux_2to1 (
    input wire A,
    input wire B,
    input wire Sel,
    output wire Y
    );

assign Y = (A & ~Sel) | (B & Sel);

endmodule