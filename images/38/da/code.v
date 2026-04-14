module SLAM_Controller(  
    input wire clk,  
    input wire reset,  
    input wire start,  
    input wire done,  
    output reg [1:0] state  
);  
    // State Encoding  
    parameter IDLE = 2'b00, MAPPING = 2'b01, LOCALIZING = 2'b10;  
    reg [1:0] current_state, next_state;  
  
    // State Transition Logic  
    always @(posedge clk or posedge reset) begin  
        if (reset)  
            current_state <= IDLE;  
        else  
            current_state <= next_state;  
    end  
  
    // Next State Logic  
    always @(*) begin  
        case (current_state)  
            IDLE: begin  
                if (start)  
                    next_state = MAPPING;  
                else  
                    next_state = IDLE;  
            end  
            MAPPING: begin  
                if (done)  
                    next_state = LOCALIZING;  
                else  
                    next_state = MAPPING;  
            end  
            LOCALIZING: begin  
                if (done)  
                    next_state = IDLE;  
                else  
                    next_state = LOCALIZING;  
            end  
            default:  
                next_state = IDLE;  
        endcase  
    end  
  
    // Output State  
    always @(posedge clk or posedge reset) begin  
        if (reset)  
            state <= IDLE;  
        else  
            state <= current_state;  
    end  
endmodule