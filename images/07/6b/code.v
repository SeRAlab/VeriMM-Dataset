module ADC_24bit (  
    input [9:0] analog_in,  
    output reg [23:0] digital_out  
);  
    always @(*) begin  
        digital_out = {14'b0, analog_in}; // Scale 10-bit input to 24-bit output  
    end  
endmodule