module top_module(out,in,sel);parameter nO = 2;
parameter nS = 1;

output[nO-1:0] out; 
input in; 
input[nS-1:0] sel; 

assign out = in << sel; 

endmodule