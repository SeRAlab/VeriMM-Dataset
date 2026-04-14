module dwt_hair_transform (  
    input [7:0] x0,  
    input [7:0] x1,  
    output [7:0] avg,  
    output [7:0] diff  
);  
    assign avg = (x0 + x1) >> 1;  
    assign diff = x0 - x1;  
endmodule