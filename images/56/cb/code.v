module top_module(
    input  [3:0] c,
    input        a,
    output       q,
    output [3:0] r
  );assign r = { c[3]&c[0] | c[2]&~c[1]&~c[0],
               ~c[2]&c[1] | c[1]&c[0] | c[3]&~c[0],
               c[3]&~c[0] | c[2]&c[1]&~c[0] | ~c[3]&~c[2]&~c[0],
               a };
  assign q = c[3] | c[2]&c[1] | c[2]&c[0];
endmodule