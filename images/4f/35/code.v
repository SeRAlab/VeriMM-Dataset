module top_module(a, b, select, y);input a, b, select;
  wire a, b, select;

  output y;
  wire y;

  wire w1, w2;

  assign w1=a&(~select);
  assign w2=b&(select);

  assign y=w1|w2;

endmodule