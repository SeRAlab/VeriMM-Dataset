module top_module(sum, carry, a, b, cin);output sum, carry;
  input a, b, cin;

  assign sum = a ^ b ^ cin;          // Sum is the XOR of a, b, and cin
  assign carry = (a & b) | (cin & (a ^ b)); // Carry is the majority function
endmodule