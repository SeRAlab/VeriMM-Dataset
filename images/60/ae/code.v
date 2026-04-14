module top_module(
    input a,
    input b,
    input c,
    output carry,
    output sum
    );assign carry = (a & b) | ( (a ^ b) & c);
    assign sum = a ^ b ^ c;endmodule