module top_module(
    input  A   ,
    output Z   ,
    input  TE  ,
    input  VPB ,
    input  VPWR,
    input  VGND,
    input  VNB
);wire A_bar;
  assign A_bar = ~A;

  assign Z = TE ? A_bar : A;

endmodule