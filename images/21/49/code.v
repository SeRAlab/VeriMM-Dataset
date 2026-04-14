module linked_list_traversal (
    input clk,
    input reset,
    input start,
    input [7:0] node_data, // Data input for current node
    input [7:0] next_node, // Pointer to next node
    output reg [7:0] out_data, // Output data from current node
    output reg done // Signal when traversal is done
);
    reg [7:0] current_node;
    reg [1:0] state; // 0: idle, 1: traverse, 2: done

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_node <= 8'b0;
            out_data <= 8'b0;
            done <= 1'b0;
            state <= 2'b00; // idle
        end else begin
            case (state)
                2'b00: begin // idle
                    if (start) begin
                        current_node <= node_data; // Start traversal
                        state <= 2'b01; // move to traverse state
                    end
                end
                2'b01: begin // traverse
                    if (current_node != 8'b0) begin
                        out_data <= current_node; // output current node data
                        current_node <= next_node; // move to next node
                    end else begin
                        done <= 1'b1; // traversal complete
                        state <= 2'b10; // move to done state
                    end
                end
                2'b10: begin // done
                    // Remain in done state
                end
            endcase
        end
    end
endmodule