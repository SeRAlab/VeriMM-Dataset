module mux2to1_hazard_detection(A, B, S, Y);  
    input A, B, S;  
    output Y;  
    reg Y;  

    always @(*) begin  
        if (S == 0) begin  
            Y = A;  
        end else if (S == 1) begin  
            Y = B;  
        end else begin  
            Y = 1'bx; // Default value in case of a hazard  
        end  
    end  
endmodule