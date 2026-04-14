module top_module(S, Cout, A, B, C);output [3:0] S;
    output Cout;
    input [3:0] A, B;
    input C;

    wire [3:0] B_neg;

    // invert B bits when C is high to implement subtraction
    assign B_neg = ~B + 1;
    wire [3:0] B_sel = C ? B_neg : B;

    // implement 4-bit adder
    wire [3:0] S_add;
    wire C_add;
    assign {C_add, S_add} = A + B_sel;

    // set output values
    assign S = S_add;
    assign Cout = C_add;

endmodule