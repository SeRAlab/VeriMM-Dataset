module a_star_fsm (  
    input clk,  
    input rst,  
    input [7:0] node_cost,  
    input valid,  
    output reg [3:0] min_node  
);  
    reg [7:0] min_cost;  
    reg [3:0] current_node;  
    parameter IDLE = 3'b000, CHECK = 3'b001, OUTPUT = 3'b010;  
    reg [2:0] state, next_state;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            state <= IDLE;  
            min_cost <= 8'hFF;  
            min_node <= 4'b0000;  
        end else begin  
            state <= next_state;  
        end  
    end  

    always @(state or valid or node_cost) begin  
        case (state)  
            IDLE: begin  
                if (valid) begin  
                    current_node = current_node + 1;  
                    next_state = CHECK;  
                end else begin  
                    next_state = IDLE;  
                end  
            end  
            CHECK: begin  
                if (node_cost < min_cost) begin  
                    min_cost = node_cost;  
                    min_node = current_node;  
                end  
                next_state = OUTPUT;  
            end  
            OUTPUT: begin  
                next_state = IDLE;  
            end  
            default: next_state = IDLE;  
        endcase  
    end  
endmodule