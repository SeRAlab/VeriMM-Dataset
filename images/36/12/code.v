module hazard_detection(input A, input B, input C, output reg hazard);  
    always @(*) begin  
        if ((A == 1'b1 && B == 1'b0 && C == 1'b1) ||  
            (A == 1'b0 && B == 1'b1 && C == 1'b1) ||  
            (A == 1'b1 && B == 1'b0 && C == 1'b0) ||  
            (A == 1'b0 && B == 1'b1 && C == 1'b0)) begin  
            hazard = 1'b1;  
        end else begin  
            hazard = 1'b0;  
        end  
    end  
endmodule