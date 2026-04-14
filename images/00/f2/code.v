module magnitude_comparator(  
    input [3:0] A,  
    input [3:0] B,  
    output reg G,  
    output reg L,  
    output reg E  
);  
  
always @(*) begin  
    if (A > B) begin  
        G = 1;  
        L = 0;  
        E = 0;  
    end else if (A < B) begin  
        G = 0;  
        L = 1;  
        E = 0;  
    end else begin  
        G = 0;  
        L = 0;  
        E = 1;  
    end  
end  
  
endmodule