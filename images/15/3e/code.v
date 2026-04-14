module fan_speed_control(  
    input wire clk,  
    input wire rst_n,  
    input wire [2:0] temp,  
    output reg [1:0] speed  
);  
    always @(posedge clk or negedge rst_n) begin  
        if (!rst_n) begin  
            speed <= 2'b00; // Initial state (Low speed)  
        end else begin  
            case (temp)  
                3'b000: speed <= 2'b00; // Low speed  
                3'b001: speed <= 2'b00; // Low speed  
                3'b010: speed <= 2'b01; // Medium speed  
                3'b011: speed <= 2'b01; // Medium speed  
                3'b100: speed <= 2'b10; // High speed  
                3'b101: speed <= 2'b10; // High speed  
                3'b110: speed <= 2'b10; // High speed  
                3'b111: speed <= 2'b10; // High speed  
                default: speed <= 2'b00; // Default to low speed  
            endcase  
        end  
    end  
endmodule