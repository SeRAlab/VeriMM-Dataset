module decoder_5to32(  
    input [4:0] binary_input,  
    output reg [31:0] decoded_output  
);  
    always @(*) begin  
        decoded_output = 32'b0;  // Initialize all outputs to 0  
        decoded_output[binary_input] = 1'b1;  // Set the output corresponding to the input value  
    end  
endmodule