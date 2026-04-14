module top_module(input  a,
                  input  b,
                  input  in_carry,
                  output sum,
                  output carry);wire sum0;
    wire carry0;
    wire carry1;

    xor (sum0, a, b);
    and (carry0, a, b);

    xor (sum, sum0, in_carry);
    and (carry1, sum0, in_carry);

    xor (carry, carry0, carry1);

endmodule