module phase_shifter(  
    input wire clk,  
    input wire rst,  
    input wire [2:0] control,  
    output reg [4:0] sine_out  
);  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            sine_out <= 5'b00000;  
        end else begin  
            case (control)  
                3'b000: sine_out <= 5'b00000; // 0 degrees  
                3'b001: sine_out <= 5'b00011; // 45 degrees  
                3'b010: sine_out <= 5'b00111; // 90 degrees  
                3'b011: sine_out <= 5'b01111; // 135 degrees  
                3'b100: sine_out <= 5'b11111; // 180 degrees  
                3'b101: sine_out <= 5'b01111; // 225 degrees  
                3'b110: sine_out <= 5'b00111; // 270 degrees  
                3'b111: sine_out <= 5'b00011; // 315 degrees  
                default: sine_out <= 5'b00000;  
            endcase  
        end  
    end  
endmodule