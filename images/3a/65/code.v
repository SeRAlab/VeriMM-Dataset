module multiplier_32bit(  
    input [31:0] A,  
    input [31:0] B,  
    input enable,  
    output reg [63:0] product  
);  
    always @(*) begin  
        if (enable)  
            product = A * B;  
        else  
            product = 64'b0;  
    end  
endmodule