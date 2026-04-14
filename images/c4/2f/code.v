module addsub(
    input [3:0] A,
    input [3:0] B,
    input sel,
    output [3:0] sum,
    output cout
    );

    wire [3:0] B_comp;

    assign B_comp = ~B + 1;

    assign sum = (sel == 1) ? A + B_comp : A + B;
    assign cout = (sel == 1) ? (A < B) : (sum < A);

endmodule