module top_module(
    input a,
    input b,
    input c,
    output carry,
    output sum
    );wire ci, si, ci2;

    assign ci = a & b;
    assign si = a ^ b;
    assign ci2 = si & c;
    assign sum = si ^ c;
    assign carry = ci | ci2;
endmodule