module LDO_Regulator(  
    input wire [1:0] control, // control signal: 00 = 0V, 01 = 3.3V, 10 = 5V, 11 = high impedance  
    output reg [3:0] output_voltage, // 4-bit output voltage representation  
    output reg in_regulation // flag indicating if the output is in regulation  
);  
    always @(*) begin  
        case(control)  
            2'b00: begin  
                output_voltage = 4'b0000; // 0V  
                in_regulation = 1'b1;  
            end  
            2'b01: begin  
                output_voltage = 4'b0011; // 3.3V (binary for 3.3)  
                in_regulation = 1'b1;  
            end  
            2'b10: begin  
                output_voltage = 4'b0101; // 5V (binary for 5)  
                in_regulation = 1'b1;  
            end  
            2'b11: begin  
                output_voltage = 4'b0000; // High impedance  
                in_regulation = 1'b0;  
            end  
            default: begin  
                output_voltage = 4'b0000;  
                in_regulation = 1'b0;  
            end  
        endcase  
    end  
endmodule