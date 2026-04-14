module top_module(input D0, D1, D2, D3, S0, S1,output Y);assign Y = S1 ? (S0 ? D3 : D2) : (S0 ? D1 : D0); 
 endmodule