module top_module(
    in,
    out
    );parameter IN_SIZE = 8;
    parameter OUT_SIZE = 16;
    
    
    input [IN_SIZE-1:0]in;
    output [OUT_SIZE-1:0]out;
    
    
    assign out = {{(OUT_SIZE - IN_SIZE){in[IN_SIZE-1]}}, in};
    
endmodule