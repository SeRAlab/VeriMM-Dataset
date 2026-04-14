module DAC_8bit (  
    input [7:0] digital_in,  
    output reg [7:0] analog_out  
);  
    always @* begin  
        analog_out = digital_in; // Direct mapping from digital input to analog output  
    end  
endmodule