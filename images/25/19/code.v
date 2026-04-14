module mux2to1 (  
    input [3:0] A,  
    input [3:0] B,  
    input S,  
    output reg [3:0] Y  
);  
    always @(*) begin  
        if (S)  
            Y = B;  
        else  
            Y = A;  
    end  
endmodule