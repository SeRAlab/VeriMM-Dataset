module max_heap_comparator(  
    input [3:0] a,  
    input [3:0] b,  
    output [3:0] max_out,  
    output a_ge_b  
);  
assign max_out = (a >= b) ? a : b;  
assign a_ge_b = (a >= b);  
endmodule