module adc_16_to_4(input [15:0] analog_in, output reg [3:0] digital_out);  
    always @(*) begin  
        digital_out = analog_in >> 12; // Shift right by 12 bits to reduce from 16 bits to 4 bits  
    end  
endmodule