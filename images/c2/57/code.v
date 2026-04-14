module adder_4bit (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    input enable,
    output [3:0] Sum,
    output Cout
);

    wire [3:0] sum;
    wire [4:0] adder_out;
    
    assign sum = A + B + Cin;
    assign adder_out = {Cin, sum};
    
    assign Cout = (adder_out > 4'b1111);
    assign Sum = (enable) ? sum : A;
    
endmodule