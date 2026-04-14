module DAC_24_to_10 (  
    input [23:0] digital_input,  
    input valid,  
    output reg [9:0] analog_output,  
    output reg output_valid  
);  
    always @(*) begin  
        if (valid) begin  
            analog_output = digital_input[23:14]; // Take the most significant 10 bits  
            output_valid = 1'b1;  
        end else begin  
            analog_output = 10'b0; // Reset output if not valid  
            output_valid = 1'b0;  
        end  
    end  
endmodule