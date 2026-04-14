module mux_2_to_1(  
    input [4:0] A,  
    input [4:0] B,  
    input S,  
    output reg [4:0] Y  
);  
    always @(*) begin  
        if (S)  
            Y = B;  
        else  
            Y = A;  
    end  
endmodule