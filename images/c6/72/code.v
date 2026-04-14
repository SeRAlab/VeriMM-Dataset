module adder4(
    // Inputs
    input cin,
    input [3:0] a,
    input [3:0] b,
    
    // Outputs
    output [3:0] sum,
    output cout
);

wire [3:0] temp;

assign temp = a + b + cin;

assign sum = temp[3:0];
assign cout = temp[4];

endmodule