module top_module(
  input [3:0] bin,
  output [3:0] bcd
);wire [3:0] temp;
  
  assign temp[3] = bin[3] & bin[2] & bin[1] & bin[0];
  assign temp[2] = (~bin[3] & bin[2] & bin[1] & bin[0]) | (bin[3] & ~bin[2] & bin[1] & bin[0]) | (bin[3] & bin[2] & ~bin[1] & bin[0]) | (bin[3] & bin[2] & bin[1] & ~bin[0]);
  assign temp[1] = (~bin[3] & ~bin[2] & bin[1] & bin[0]) | (bin[3] & ~bin[2] & ~bin[1] & bin[0]) | (bin[3] & bin[2] & ~bin[1] & ~bin[0]) | (~bin[3] & bin[2] & bin[1] & ~bin[0]);
  assign temp[0] = (~bin[3] & ~bin[2] & ~bin[1] & bin[0]) | (bin[3] & ~bin[2] & ~bin[1] & ~bin[0]) | (bin[3] & bin[2] & ~bin[1] & ~bin[0]) | (bin[3] & ~bin[2] & bin[1] & ~bin[0]);

  assign bcd = temp;

endmodule