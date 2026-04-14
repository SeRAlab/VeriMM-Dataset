module nearest_neighbor_interpolation(  
    input [7:0] x1,  
    input [7:0] y1,  
    input [7:0] x2,  
    input [7:0] y2,  
    output reg [7:0] output_pixel  
);  
    always @(*) begin  
        if ((x1 - x2)*(x1 - x2) + (y1 - y2)*(y1 - y2) <= 1)  
            output_pixel = x1;  
        else  
            output_pixel = x2;  
    end  
endmodule