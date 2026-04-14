module adc_simulator (  
    input [2:0] voltage_level,  
    output reg [7:0] digital_output  
);  
  
always @(*) begin  
    case (voltage_level)  
        3'b000: digital_output = 8'b00000000;  
        3'b001: digital_output = 8'b00111111;  
        3'b010: digital_output = 8'b01111111;  
        3'b011: digital_output = 8'b01111111;  
        3'b100: digital_output = 8'b11111111;  
        default: digital_output = 8'b11111111;  
    endcase  
end  
endmodule