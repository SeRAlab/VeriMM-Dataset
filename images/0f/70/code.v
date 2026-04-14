module dfs_tree(input clk,  
                input reset,  
                input [7:0] node_value,  
                input go_left,  
                input go_right,  
                output reg [7:0] output_value,  
                output reg done);  

    reg [2:0] state;  
    parameter IDLE = 3'b000, TRAVERSE = 3'b001, DONE = 3'b010;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= IDLE;  
            output_value <= 0;  
            done <= 0;  
        end else begin  
            case (state)  
                IDLE: begin  
                    if (go_left || go_right) begin  
                        state <= TRAVERSE;  
                        output_value <= node_value;  
                        done <= 0;  
                    end  
                end  
                TRAVERSE: begin  
                    if (go_left) begin  
                        // Logic for traversing left child (for simplicity, just output node_value)  
                        output_value <= node_value - 1; // Assume left child is value - 1  
                        state <= DONE;  
                    end else if (go_right) begin  
                        // Logic for traversing right child  
                        output_value <= node_value + 1; // Assume right child is value + 1  
                        state <= DONE;  
                    end  
                end  
                DONE: begin  
                    done <= 1;  
                    state <= IDLE;  
                end  
            endcase  
        end  
    end  
endmodule