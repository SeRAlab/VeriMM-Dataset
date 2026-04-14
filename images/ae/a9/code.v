module adder_4bit(
    input [3:0] a, b,
    output [3:0] sum,
    output carry_out);
    
    assign {carry_out, sum} = a + b;
endmodule