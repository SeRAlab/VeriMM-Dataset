module multiplier_16bit (  
    input [15:0] A,  
    input [15:0] B,  
    output reg [31:0] product  
);  
    always @(*) begin  
        product = A * B;  
    end  
endmodule