module top_module(output reg q, input d, input ck);always @(posedge ck) 
    q <= d; 
endmodule