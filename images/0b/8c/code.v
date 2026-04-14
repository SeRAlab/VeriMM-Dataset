module decoder_4_to_16(  
    input [3:0] A,  
    output reg [15:0] Y  
);  
    always @(*) begin  
        Y = 16'b0; // Deassert all outputs  
        Y[A] = 1'b1; // Assert the output corresponding to the input  
    end  
endmodule