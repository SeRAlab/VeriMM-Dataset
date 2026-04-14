module mux_2to1 (
    input wire a,
    input wire b,
    input wire sel,
    output wire y,
    output wire forward
);
    assign y = (sel) ? b : a;
    assign forward = (a == b) ? 1'b1 : 1'b0;
endmodule