module ADC_8bit (  
    input wire clk,  
    input wire reset,  
    input wire [2:0] analog_in,  
    output reg [7:0] digital_out  
);  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            digital_out <= 8'b00000000;  
        end else begin  
            case (analog_in)  
                3'b000: digital_out <= 8'b00000000;  
                3'b001: digital_out <= 8'b00111111;  
                3'b010: digital_out <= 8'b01111111;  
                3'b011: digital_out <= 8'b10111111;  
                3'b100: digital_out <= 8'b11111111;  
                3'b101: digital_out <= 8'b10000000;  
                3'b110: digital_out <= 8'b11000000;  
                3'b111: digital_out <= 8'b11111111;  
                default: digital_out <= 8'b00000000;  
            endcase  
        end  
    end  
endmodule