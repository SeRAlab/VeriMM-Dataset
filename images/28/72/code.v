module rrt_state_machine (  
    input clk,  
    input reset,  
    input trigger_explore,  
    input trigger_goal,  
    output reg [1:0] state  
);  
    parameter IDLE = 2'b00;  
    parameter EXPLORE = 2'b01;  
    parameter GOAL = 2'b10;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= IDLE;  
        end else begin  
            case (state)  
                IDLE: begin  
                    if (trigger_explore)  
                        state <= EXPLORE;  
                end  
                EXPLORE: begin  
                    if (trigger_goal)  
                        state <= GOAL;  
                end  
                GOAL: begin  
                    state <= IDLE;  
                end  
            endcase  
        end  
    end  
endmodule