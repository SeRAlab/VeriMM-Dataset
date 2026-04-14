module four_bit_multiplier (  
    input [3:0] A,  
    input [3:0] B,  
    output reg [7:0] Product  
);  

always @(*) begin  
    Product = A * B;  
end  
endmodule