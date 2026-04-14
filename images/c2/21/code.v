module adder_subtractor (
    input [3:0] A,
    input [3:0] B,
    input C,
    output [3:0] S,
    output Cout
);

    wire [3:0] B_comp;
    wire [3:0] temp_sum;
    wire temp_carry;

    assign B_comp = ~B + 1;

    assign temp_sum = (C == 0) ? A + B : A + B_comp;
    assign Cout = (C == 0 && temp_sum[4]) || (C == 1 && !temp_sum[4]);
    assign S = temp_sum[3:0];

endmodule