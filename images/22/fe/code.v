module mux32 (
    input [31:0] A,
    input [31:0] B,
    input sel,
    output [31:0] Y
);
    assign Y = (sel == 1'b0) ? A : B;
endmodule