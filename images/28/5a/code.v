module mux_with_forwarding(
    input wire A,
    input wire B,
    input wire S,
    output wire Y
);
assign Y = (A == B) ? 1'b0 : (S ? B : A);
endmodule