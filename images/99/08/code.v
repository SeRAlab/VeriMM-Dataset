module top_module(input [5:0] In, output [7:0] Out);assign Out = { In[5], In[5], In};
endmodule