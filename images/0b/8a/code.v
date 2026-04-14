module fan_speed_control(  
    input wire clk,  
    input wire reset,  
    input wire [3:0] temperature,  
    output reg [1:0] fan_speed  
);  
    // State encoding  
    parameter LOW = 2'b00, MEDIUM = 2'b01, HIGH = 2'b10;  
    reg [1:0] current_state, next_state;  
  
    // State transition logic  
    always @(posedge clk or posedge reset) begin  
        if (reset)  
            current_state <= LOW;  
        else  
            current_state <= next_state;  
    end  
  
    // Next state logic  
    always @(*) begin  
        case (current_state)  
            LOW: begin  
                if (temperature >= 4)  
                    next_state = MEDIUM;  
                else  
                    next_state = LOW;  
            end  
            MEDIUM: begin  
                if (temperature >= 8)  
                    next_state = HIGH;  
                else if (temperature < 4)  
                    next_state = LOW;  
                else  
                    next_state = MEDIUM;  
            end  
            HIGH: begin  
                if (temperature < 8)  
                    next_state = MEDIUM;  
                else  
                    next_state = HIGH;  
            end  
            default: next_state = LOW;  
        endcase  
    end  
  
    // Output logic  
    always @(posedge clk or posedge reset) begin  
        if (reset)  
            fan_speed <= 2'b00;  
        else  
            fan_speed <= current_state;  
    end  
endmodule