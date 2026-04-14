module ADC_Decoder(  
    input [15:0] binary_input,  
    output reg [15:0] decimal_output  
);  
    always @(*) begin  
        if (binary_input[15:12] < 4'b1000)  // Check if the highest 4 bits are less than 8 (valid range)  
            decimal_output = binary_input;  
        else  
            decimal_output = 16'b0;  // Invalid range  
    end  
endmodule