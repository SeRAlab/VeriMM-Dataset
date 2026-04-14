module top_module(output sumout,output cout,input p,input g,input cin);assign sumout = p ^ cin; 
  assign cout = p ? cin : g; 
 endmodule