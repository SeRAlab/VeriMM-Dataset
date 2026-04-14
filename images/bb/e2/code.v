module top_module(ack0, ack1, ack2, ack3, ack);input ack0, ack1, ack2, ack3;
  output ack;
  assign ack = ack0 || ack1 || ack2 || ack3;
endmodule