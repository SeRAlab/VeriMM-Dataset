module adder_8bit(
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout);
    
    assign {cout, sum} = a + b + cin; // Perform addition with carry-in and produce carry-out
endmodule