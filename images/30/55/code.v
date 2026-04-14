module median_filter (  
    input wire x1,  
    input wire x2,  
    input wire x3,  
    output wire m  
);  
    assign m = (x1 & x2) | (x2 & x3) | (x3 & x1);  
endmodule