module top_module(
    input [3:0] A,
    input [3:0] B,
    input M,
    output [3:0] S
);wire [3:0] A_inv;
    wire [3:0] B_inv;
    wire [3:0] C_in;
    wire [3:0] S_add;
    wire [3:0] S_sub;

    //Invert B
    assign B_inv = ~B;

    //Create carry-in for subtraction
    assign C_in = M ? B_inv : 4'b0000;

    //Adder and subtractor
    assign S_add = A + B;
    assign S_sub = A + B_inv + C_in;

    //Select output based on mode
    assign S = M ? S_sub : S_add;

endmodule