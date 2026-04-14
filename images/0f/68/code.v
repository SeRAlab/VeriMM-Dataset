module linked_list_traversal(
    input clk,
    input reset,
    input start,
    input [3:0] node_data,
    input [3:0] next_node,
    output reg [3:0] output_data,
    output reg done
);
    reg [3:0] current_node;
    reg [1:0] state;
    
    localparam IDLE = 2'b00,
               TRAVERSE = 2'b01,
               DONE = 2'b10;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            output_data <= 4'b0000;
            done <= 0;
            current_node <= 4'b0000;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        current_node <= node_data;
                        state <= TRAVERSE;
                        done <= 0;
                    end
                end
                
                TRAVERSE: begin
                    if (current_node != 4'b0000) begin
                        output_data <= current_node;
                        current_node <= next_node; // Move to next node
                    end else begin
                        state <= DONE;
                        done <= 1;
                    end
                end
                
                DONE: begin
                    // Stay in done state
                end
            endcase
        end
    end
endmodule