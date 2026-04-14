module dwt_1d (  
    input signed [7:0] x0,  
    input signed [7:0] x1,  
    input signed [7:0] x2,  
    input signed [7:0] x3,  
    output signed [7:0] low_pass0,  
    output signed [7:0] low_pass1,  
    output signed [7:0] high_pass0,  
    output signed [7:0] high_pass1  
);  
    assign low_pass0 = (x0 + x1 + x2 + x3) >> 2;  
    assign low_pass1 = (x0 + x1 - x2 - x3) >> 2;  
    assign high_pass0 = (x0 - x1 + x2 - x3) >> 2;  
    assign high_pass1 = (x0 - x1 - x2 + x3) >> 2;  
endmodule