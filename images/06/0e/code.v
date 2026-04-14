module adc_8bit (  
    input [7:0] analog_in,  
    output reg [2:0] digital_out  
);  

always @(*) begin  
    if (analog_in <= 85)  
        digital_out = 3'b000;  
    else if (analog_in <= 170)  
        digital_out = 3'b001;  
    else  
        digital_out = 3'b010;  
end  
endmodule