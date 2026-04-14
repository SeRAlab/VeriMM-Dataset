module state_space_controller(  
    input clk,  
    input reset,  
    input [1:0] signal_in,  
    output reg [1:0] state_out  
);  
    // State encoding  
    parameter IDLE = 2'b00;  
    parameter PROCESSING = 2'b01;  
    parameter COMPLETED = 2'b10;  
    
    reg [1:0] current_state, next_state;  
    
    // State transition logic  
    always @(*) begin  
        case (current_state)  
            IDLE: begin  
                if (signal_in == 2'b01)  
                    next_state = PROCESSING;  
                else  
                    next_state = IDLE;  
            end  
            PROCESSING: begin  
                if (signal_in == 2'b10)  
                    next_state = COMPLETED;  
                else  
                    next_state = PROCESSING;  
            end  
            COMPLETED: begin  
                if (reset)  
                    next_state = IDLE;  
                else  
                    next_state = COMPLETED;  
            end  
            default: next_state = IDLE;  
        endcase  
    end  
    
    // State update logic  
    always @(posedge clk or posedge reset) begin  
        if (reset)  
            current_state <= IDLE;  
        else  
            current_state <= next_state;  
    end  
    
    // Output logic  
    always @(current_state) begin  
        state_out = current_state;  
    end  
endmodule