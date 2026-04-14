module linked_list_traversal(
    input clk,
    input reset,
    input enable,
    input [7:0] head_pointer,
    output reg [7:0] current_value,
    output reg done
);
    reg [7:0] linked_list [0:15]; // Example linked list with 16 nodes
    reg [3:0] current_index; // Index for traversal

    // Initialize linked list values for testing
    initial begin
        linked_list[0] = 8'd1;
        linked_list[1] = 8'd2;
        linked_list[2] = 8'd3;
        linked_list[3] = 8'd4;
        linked_list[4] = 8'd5;
        linked_list[5] = 8'd0; // End of list indicator
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_index <= head_pointer; // Set to head pointer
            current_value <= 8'd0;
            done <= 1'b0;
        end else if (enable) begin
            if (linked_list[current_index] != 8'd0) begin
                current_value <= linked_list[current_index];
                current_index <= current_index + 1;
                done <= 1'b0; // Still traversing
            end else begin
                current_value <= 8'd0; // No more nodes
                done <= 1'b1; // Traversal done
            end
        end
    end
endmodule