module DAC_16bit (  
    input [15:0] digital_input,  
    input enable,  
    output reg [15:0] analog_output  
);  

    parameter Vmax = 16'hFFFF; // Max output value corresponding to Vmax (5V)  

    always @(*) begin  
        if (enable)  
            analog_output = digital_input;  
        else  
            analog_output = 16'h0000; // Output 0V when not enabled  
    end  
endmodule