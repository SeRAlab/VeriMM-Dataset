module dfs_tree (  
    input clk,  
    input reset,  
    input start,  
    input [3:0] node_value,  
    output reg [3:0] output_value,  
    output reg done  
);  
    reg [2:0] state;  
    reg [2:0] next_state;  
    reg [3:0] stack [0:7];  
    reg [2:0] stack_ptr;  
  
    // State definitions  
    parameter IDLE = 3'd0;  
    parameter PUSH = 3'd1;  
    parameter POP = 3'd2;  
    parameter VISIT = 3'd3;  
    parameter DONE = 3'd4;  
    
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= IDLE;  
            stack_ptr <= 0;  
            output_value <= 0;  
            done <= 0;  
        end else begin  
            state <= next_state;  
        end  
    end  
  
    always @(*) begin  
        case(state)  
            IDLE: begin  
                if (start) begin  
                    next_state = PUSH;  
                end else begin  
                    next_state = IDLE;  
                end  
                done = 0;  
            end  
            PUSH: begin  
                if (stack_ptr < 8) begin  
                    stack[stack_ptr] = node_value;  
                    stack_ptr = stack_ptr + 1;  
                    next_state = VISIT;  
                end else begin  
                    next_state = DONE;  
                end  
            end  
            VISIT: begin  
                if (stack_ptr > 0) begin  
                    output_value = stack[stack_ptr - 1];  
                    stack_ptr = stack_ptr - 1;  
                    next_state = POP;  
                end else begin  
                    next_state = DONE;  
                end  
            end  
            POP: begin  
                next_state = VISIT;  
            end  
            DONE: begin  
                done = 1;  
                next_state = IDLE;  
            end  
            default: next_state = IDLE;  
        endcase  
    end  
endmodule