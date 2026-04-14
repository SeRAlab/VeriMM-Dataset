module top_module(d0,d1,sel,q);input d0,d1,sel;
output q;
assign q = sel ? d1 : d0;endmodule