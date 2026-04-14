module fsm_example(  
    input clk,  
    input reset,  
    input start,  
    input done,  
    output reg [1:0] state  
);  
    // State encoding  
    parameter IDLE = 2'b00,  
              PROCESS = 2'b01,  
              DONE = 2'b10;  
  
    // Current state and next state  
    reg [1:0] current_state, next_state;  
  
    // State transition logic  
    always @ (posedge clk or posedge reset) begin  
        if (reset)  
            current_state <= IDLE;  
        else  
            current_state <= next_state;  
    end  
  
    // Next state logic  
    always @ (*) begin  
        case (current_state)  
            IDLE: begin  
                if (start)  
                    next_state = PROCESS;  
                else  
                    next_state = IDLE;  
            end  
            PROCESS: begin  
                if (done)  
                    next_state = DONE;  
                else  
                    next_state = PROCESS;  
            end  
            DONE: begin  
                next_state = IDLE;  
            end  
            default: next_state = IDLE;  
        endcase  
    end  
  
    // Output logic  
    always @ (posedge clk) begin  
        state <= current_state;  
    end  
endmodule