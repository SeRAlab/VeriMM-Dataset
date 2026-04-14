module median_filter(  
    input [2:0] x1,  
    input [2:0] x2,  
    input [2:0] x3,  
    output reg [2:0] median  
);  
always @(*) begin  
    if ((x1 <= x2 && x1 >= x3) || (x1 >= x2 && x1 <= x3))  
        median = x1;  
    else if ((x2 <= x1 && x2 >= x3) || (x2 >= x1 && x2 <= x3))  
        median = x2;  
    else  
        median = x3;  
end  
endmodule