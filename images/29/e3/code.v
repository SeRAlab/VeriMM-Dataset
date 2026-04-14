module RRT_StateMachine(  
    input clk,  
    input rst,  
    input explore,  
    output reg [1:0] state  
);  
    // State encoding  
    parameter IDLE = 2'b00,  
              EXPLORE = 2'b01,  
              GOAL = 2'b10;  

    // State register  
    always @(posedge clk or posedge rst) begin  
        if (rst)  
            state <= IDLE;  
        else begin  
            case (state)  
                IDLE: begin  
                    if (explore)  
                        state <= EXPLORE;  
                end  
                EXPLORE: begin  
                    // Assume after one cycle of exploration, we can go to GOAL  
                    state <= GOAL;  
                end  
                GOAL: begin  
                    state <= IDLE;  
                end  
                default: state <= IDLE;  
            endcase  
        end  
    end  
endmodule