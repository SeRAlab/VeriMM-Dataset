module hazard_detection(  
    input [4:0] A,  
    input [4:0] B,  
    output reg hazard  
);  
    always @(*) begin  
        if ((A[4] ^ A[3]) | (B[4] ^ B[3]) | (A[4] ^ B[4]) | (A[3] ^ B[3]))  
            hazard = 1'b1;  
        else  
            hazard = 1'b0;  
    end  
endmodule