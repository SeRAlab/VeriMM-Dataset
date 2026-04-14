module top_module(oe, en,en_);output oe; 
 input en, en_; 
  assign oe = (en && (~en_)); 
 endmodule