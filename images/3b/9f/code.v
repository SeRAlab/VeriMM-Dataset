module ADC_8bit (  
    input [2:0] analog_input,  
    output reg [7:0] digital_output  
);  
    always @(*) begin  
        digital_output = analog_input * 32; // Maps 0-7 to 0-255  
    end  
endmodule