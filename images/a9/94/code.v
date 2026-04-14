module adder_16bit(
    input wire [15:0] A,
    input wire [15:0] B,
    output wire [15:0] sum,
    output wire carry_out
    );

wire [3:0] carry;

adder_4bit u0 (
    .A(A[3:0]),
    .B(B[3:0]),
    .carry_in(1'b0),
    .sum(sum[3:0]),
    .carry_out(carry[0])
    );

adder_4bit u1 (
    .A(A[7:4]),
    .B(B[7:4]),
    .carry_in(carry[0]),
    .sum(sum[7:4]),
    .carry_out(carry[1])
    );

adder_4bit u2 (
    .A(A[11:8]),
    .B(B[11:8]),
    .carry_in(carry[1]),
    .sum(sum[11:8]),
    .carry_out(carry[2])
    );

adder_4bit u3 (
    .A(A[15:12]),
    .B(B[15:12]),
    .carry_in(carry[2]),
    .sum(sum[15:12]),
    .carry_out(carry_out)
    );

endmodule

module adder_4bit(
    input wire [3:0] A,
    input wire [3:0] B,
    input wire carry_in,
    output wire [3:0] sum,
    output wire carry_out
    );

assign {carry_out, sum} = A + B + carry_in;

endmodule