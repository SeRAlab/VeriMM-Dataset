module top_module(ack0, ack1, ack2, ack3, ack);wire _0_;
  wire _1_;
  (* src = "ackor.v:1" *)
  output ack;
  (* src = "ackor.v:1" *)
  input ack0;
  (* src = "ackor.v:1" *)
  input ack1;
  (* src = "ackor.v:1" *)
  input ack2;
  (* src = "ackor.v:1" *)
  input ack3;
  assign _0_ = ack1 | ack0;
  assign _1_ = _0_ | ack2;
  assign ack = _1_ | ack3;endmodule