module top_module(PPP,GPP,C4,C8,C12,PP,GP,CI);output          PPP, GPP, C4, C8, C12;
  input  [3:0]    PP, GP;
  input           CI;

      assign C4=GP[0] | PP[0]&CI,
             C8=GP[1] | PP[1]&GP[0] | PP[1]&PP[0]&CI,
             C12=GP[2] | PP[2]&GP[1] | PP[2]&PP[1]&GP[0] | PP[2]&PP[1]&PP[0]&CI,
             GPP=GP[3] | PP[3]&GP[2] | PP[3]&PP[2]&GP[1] | PP[3]&PP[2]&PP[1]&GP[0],
             PPP = & PP[3:0];

endmodule