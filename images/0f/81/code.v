module decoder_4to16 (  
    input [3:0] A,  
    output reg [15:0] Y  
);  
    always @(*) begin  
        Y = 16'b0; // Initialize all outputs to 0  
        Y[A] = 1'b1; // Set the output corresponding to the input value  
    end  
endmodule