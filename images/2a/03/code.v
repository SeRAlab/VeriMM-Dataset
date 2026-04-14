module robot_slam (  
    input clk,  
    input rst,  
    input start,  
    input [1:0] direction,  // 00: up, 01: down, 10: left, 11: right  
    output reg [3:0] x,  // x position  
    output reg [3:0] y,  // y position  
    output reg [1:0] state // 00: IDLE, 01: MOVE, 10: MAP  
);  
    // State definitions  
    parameter IDLE = 2'b00, MOVE = 2'b01, MAP = 2'b10;  
    reg [1:0] next_state;  
    
    // State transition logic  
    always @(posedge clk or posedge rst) begin  
        if (rst)  
            state <= IDLE;  
        else  
            state <= next_state;  
    end  
    
    // Next state logic  
    always @(*) begin  
        case (state)  
            IDLE: begin  
                if (start)  
                    next_state = MOVE;  
                else  
                    next_state = IDLE;  
            end  
            MOVE: begin  
                next_state = MAP;  
            end  
            MAP: begin  
                next_state = IDLE;  
            end  
            default: next_state = IDLE;  
        endcase  
    end  
    
    // Position update logic  
    always @(posedge clk) begin  
        if (rst) begin  
            x <= 4'b0000;  
            y <= 4'b0000;  
        end else begin  
            case (state)  
                MOVE: begin  
                    case (direction)  
                        2'b00: y <= y + 1; // move up  
                        2'b01: y <= y - 1; // move down  
                        2'b10: x <= x - 1; // move left  
                        2'b11: x <= x + 1; // move right  
                    endcase  
                end  
                default: ;  
            endcase  
        end  
    end  
endmodule