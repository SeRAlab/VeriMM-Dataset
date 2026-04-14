module max_heap_comparator (  
    input [3:0] a,  
    input [3:0] b,  
    input [3:0] c,  
    output [3:0] max_out  
);  
    assign max_out = (a >= b) ? (a >= c ? a : c) : (b >= c ? b : c);  
endmodule