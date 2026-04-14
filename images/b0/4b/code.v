module top_module(busA, busB, busXOR);input [7:0] busA;
input [7:0] busB;
output [7:0] busXOR;

wire [7:0] temp1, temp2, temp3, temp4;

// XOR operation
assign temp1 = busA ^ busB;

// Invert the inputs
assign temp2 = ~busA;
assign temp3 = ~busB;

// AND operation
assign temp4 = temp2 & temp3;

// Final XOR operation
assign busXOR = temp1 ^ temp4;

endmodule