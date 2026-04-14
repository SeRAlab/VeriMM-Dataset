module full_adder_4bit(
    input [3:0] a,      // 4-bit binary input.
    input [3:0] b,      // 4-bit binary input.
    input cin,          // Carry-in bit.
    output [3:0] sum,   // 4-bit sum output.
    output cout         // Carry-out bit.
);

wire c1, c2, c3;

// Full adder logic
assign {c1, sum[0]} = a[0] + b[0] + cin;
assign {c2, sum[1]} = a[1] + b[1] + c1;
assign {c3, sum[2]} = a[2] + b[2] + c2;
assign {cout, sum[3]} = a[3] + b[3] + c3;

endmodule