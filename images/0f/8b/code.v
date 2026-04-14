module adc_8bit_to_4bit(input [7:0] analog_input, output reg [3:0] digital_output);  
    always @(*) begin  
        digital_output = analog_input / 16;  
    end  
endmodule