module adc_16bit (input [9:0] analog_in, output [15:0] digital_out);  
    assign digital_out = (analog_in * 65535) / 1023;  
endmodule