module mux2to1_with_forwarding (
    input wire [7:0] A,
    input wire [7:0] B,
    input wire sel,
    output wire [7:0] out
);
    assign out = (A == B) ? A : (sel ? B : A);
endmodule