module fan_speed_control(  
    input wire clk,  
    input wire rst,  
    input wire [3:0] TEMP,  
    output reg [2:0] FAN_SPEED  
);  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            FAN_SPEED <= 3'b000; // OFF  
        end else begin  
            case (TEMP)  
                4'b0000, 4'b0001, 4'b0010, 4'b0011: FAN_SPEED <= 3'b000; // OFF  
                4'b0100, 4'b0101, 4'b0110, 4'b0111: FAN_SPEED <= 3'b001; // LOW  
                4'b1000, 4'b1001, 4'b1010, 4'b1011: FAN_SPEED <= 3'b010; // MEDIUM  
                4'b1100, 4'b1101, 4'b1110, 4'b1111: FAN_SPEED <= 3'b011; // HIGH  
                default: FAN_SPEED <= 3'b000; // Default to OFF  
            endcase  
        end  
    end  
endmodule