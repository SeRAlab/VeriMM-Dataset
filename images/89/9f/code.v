module top_module( 
    pa, pb, pc, pd, pe,
    pf  );input  pa, pb, pc, pd, pe;
  output pf;
  wire new_n7_, new_n8_, new_n9_, new_n10_, new_n11_, new_n12_, new_n13_,
    new_n14_, new_n15_, new_n16_, new_n17_, new_n18_, new_n19_, new_n20_,
    new_n21_, new_n22_;
  assign new_n7_ = ~pa & ~pe;
  assign new_n8_ = ~pd & new_n7_;
  assign new_n9_ = ~pb & ~pe;
  assign new_n10_ = ~pd & new_n9_;
  assign new_n11_ = ~pa & ~pc;
  assign new_n12_ = ~pd & new_n11_;
  assign new_n13_ = ~pb & ~pc;
  assign new_n14_ = ~pd & new_n13_;
  assign new_n15_ = ~pa & ~pb;
  assign new_n16_ = ~pd & new_n15_;
  assign new_n17_ = ~pc & ~pe;
  assign new_n18_ = ~pd & new_n17_;
  assign new_n19_ = ~new_n14_ & ~new_n16_;
  assign new_n20_ = ~new_n18_ & new_n19_;
  assign new_n21_ = ~new_n8_ & ~new_n10_;
  assign new_n22_ = ~new_n12_ & new_n21_;
  assign pf = new_n20_ & new_n22_;
endmodule