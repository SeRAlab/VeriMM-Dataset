module top_module(input a, b, output out);reg p1, p2;
  wire s1, s2, s3;

  assign s1 = a ^ b;
  assign s2 = p1 ^ s1;
  assign s3 = p2 ^ s2;
  assign out = s3;

  always @(a, b) begin
    p1 <= s1;
    p2 <= s2;
  end
endmodule