module decoder_5to32 (  
    input [4:0] A,  
    output reg [31:0] Y  
);  
    always @(*) begin  
        Y = 32'b0; // Set all outputs to 0  
        Y[A] = 1'b1; // Set the output corresponding to the input value to 1  
    end  
endmodule