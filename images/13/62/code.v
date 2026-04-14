module AStarFSM (  
    input clk,  
    input reset,  
    input valid,  
    input [3:0] current_node,  
    input [3:0] goal_node,  
    input [7:0] g_cost,  
    input [7:0] h_cost,  
    output reg [7:0] f_cost,  
    output reg [3:0] next_node  
);  
    reg [2:0] state;  
    parameter IDLE = 3'b000, COMPUTE = 3'b001, OUTPUT = 3'b010;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= IDLE;  
            f_cost <= 8'd0;  
            next_node <= 4'd0;  
        end else begin  
            case (state)  
                IDLE: begin  
                    if (valid) begin  
                        state <= COMPUTE;  
                    end  
                end  
                COMPUTE: begin  
                    f_cost <= g_cost + h_cost;  
                    // Here, we can simply set next_node to current_node + 1 for demonstration  
                    next_node <= current_node + 4'd1;  
                    state <= OUTPUT;  
                end  
                OUTPUT: begin  
                    state <= IDLE;  
                end  
            endcase  
        end  
    end  
endmodule