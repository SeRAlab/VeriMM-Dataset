module median_filter (  
    input wire a,  
    input wire b,  
    input wire c,  
    output wire median  
);  
    assign median = (a & b) | (b & c) | (c & a);  
endmodule