module mux2to1 (
    input wire A,
    input wire B,
    input wire S,
    output wire Y
);
    assign Y = (S == 1'b0) ? A : B;
endmodule