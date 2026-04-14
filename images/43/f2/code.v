module full_adder_4bit(
    input [3:0] a,    // 4-bit input A
    input [3:0] b,    // 4-bit input B
    input cin,        // Carry-in
    
    output [3:0] sum, // 4-bit sum output
    output cout       // Carry-out
);

wire [3:0] carry; // Intermediate carry wires

// Full adder for bit 0
assign {carry[0], sum[0]} = a[0] + b[0] + cin;

// Full adder for bit 1
assign {carry[1], sum[1]} = a[1] + b[1] + carry[0];

// Full adder for bit 2
assign {carry[2], sum[2]} = a[2] + b[2] + carry[1];

// Full adder for bit 3
assign {carry[3], sum[3]} = a[3] + b[3] + carry[2];

// Carry-out is the carry from the most significant bit
assign cout = carry[3];

endmodule