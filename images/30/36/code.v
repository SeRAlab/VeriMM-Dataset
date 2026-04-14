module robot_fsm (  
    input clk,  
    input reset,  
    input obstacle_detected,  
    output reg [1:0] state  
);  
    // State encoding  
    parameter IDLE = 2'b00,  
              MOVE_FORWARD = 2'b01,  
              TURN_LEFT = 2'b10,  
              TURN_RIGHT = 2'b11;  
  
    // Sequential logic for state transitions  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= IDLE;  
        end else begin  
            case (state)  
                IDLE: state <= (obstacle_detected) ? TURN_RIGHT : MOVE_FORWARD;  
                MOVE_FORWARD: state <= (obstacle_detected) ? TURN_RIGHT : MOVE_FORWARD;  
                TURN_LEFT: state <= (obstacle_detected) ? TURN_RIGHT : MOVE_FORWARD;  
                TURN_RIGHT: state <= (obstacle_detected) ? TURN_RIGHT : MOVE_FORWARD;  
                default: state <= IDLE;  
            endcase  
        end  
    end  
endmodule