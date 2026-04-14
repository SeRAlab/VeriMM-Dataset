module non_maximum_suppression(  
    input [7:0] center,  
    input [7:0] neighbor1,  
    input [7:0] neighbor2,  
    output reg edge_detected  
);  
    always @(*) begin  
        if (center > neighbor1 && center > neighbor2)  
            edge_detected = 1'b1;  
        else  
            edge_detected = 1'b0;  
    end  
endmodule