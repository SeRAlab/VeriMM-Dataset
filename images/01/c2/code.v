module decoder_4to16 (  
    input [3:0] binary_input,  
    output reg [15:0] decoder_output  
);  
    always @* begin  
        decoder_output = 16'b0; // Initialize all outputs to 0  
        decoder_output[binary_input] = 1'b1; // Set the selected output to 1  
    end  
endmodule