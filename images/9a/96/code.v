module full_adder (
    input wire a,
    input wire b,
    input wire carry_in,
    output wire sum,
    output wire carry_out
);

    assign sum = a ^ b ^ carry_in;
    assign carry_out = (a & b) | (b & carry_in) | (a & carry_in);

endmodule

module ripple_carry_adder_16bit (
    input wire [15:0] a,
    input wire [15:0] b,
    input wire carry_in,
    output wire [15:0] sum,
    output wire carry_out
);
    wire [15:0] carry;

    full_adder fa0 (.a(a[0]), .b(b[0]), .carry_in(carry_in), .sum(sum[0]), .carry_out(carry[0]));
    generate
        genvar i;
        for (i = 1; i < 16; i = i + 1) begin : adder_stage
            full_adder fa (.a(a[i]), .b(b[i]), .carry_in(carry[i-1]), .sum(sum[i]), .carry_out(carry[i]));
        end
    endgenerate

    assign carry_out = carry[15];

endmodule