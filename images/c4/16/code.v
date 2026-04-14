module simple_arithmetic (
    input [7:0] A,
    input [7:0] B,
    input [1:0] op,
    output [7:0] out
);

    wire [7:0] add_out = A + B;
    wire [7:0] sub_out = A - B;
    wire [7:0] and_out = A & B;
    wire [7:0] or_out = A | B;

    assign out = (op == 2'b00) ? add_out :
                 (op == 2'b01) ? sub_out :
                 (op == 2'b10) ? and_out :
                                 or_out;

endmodule