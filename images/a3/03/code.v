module top_module(In, Out_n);input wire [3:0] In;
    output wire [9:0] Out_n;
    wire [9:0] Out;
    assign Out_n = ~Out;
    assign Out[0] = ~In[3] & ~In[2] & ~In[1] & ~In[0];
    assign Out[1] = ~In[3] & ~In[2] & ~In[1] & In[0];
    assign Out[2] = ~In[3] & ~In[2] & In[1] & ~In[0];
    assign Out[3] = ~In[3] & ~In[2] & In[1] & In[0];
    assign Out[4] = ~In[3] & In[2] & ~In[1] & ~In[0];
    assign Out[5] = ~In[3] & In[2] & ~In[1] & In[0];
    assign Out[6] = ~In[3] & In[2] & In[1] & ~In[0];
    assign Out[7] = ~In[3] & In[2] & In[1] & In[0];
    assign Out[8] = In[3] & ~In[2] & ~In[1] & ~In[0];
    assign Out[9] = In[3] & ~In[2] & ~In[1] & In[0];endmodule