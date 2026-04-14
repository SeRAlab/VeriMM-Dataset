module adc_8bit (  
    input [2:0] voltage_input,  
    output reg [7:0] digital_output  
);  

always @(*) begin  
    case (voltage_input)  
        3'b000: digital_output = 8'b00000001;  
        3'b001: digital_output = 8'b00000010;  
        3'b010: digital_output = 8'b00000100;  
        3'b011: digital_output = 8'b00001000;  
        3'b100: digital_output = 8'b00010000;  
        3'b101: digital_output = 8'b00100000;  
        3'b110: digital_output = 8'b01000000;  
        3'b111: digital_output = 8'b10000000;  
        default: digital_output = 8'b00000000;  
    endcase  
end  
endmodule