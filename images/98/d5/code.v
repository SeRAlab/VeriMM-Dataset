module top_module(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    input Sel,
    output [3:0] S,
    output Cout
);wire [3:0] B_comp;
    wire [3:0] temp;
    wire [3:0] C_comp;
    wire C_temp;

    //2's complement of B
    assign B_comp = (~B) + 1;

    //Addition
    assign temp = A + B + Cin;

    //Subtraction
    assign C_comp = A + B_comp + Cin;

    //Select output based on Sel
    assign S = Sel ? C_comp : temp;

    //Carry-out
    assign Cout = (Sel && C_comp[4]) || (!Sel && temp[4]);

endmodule