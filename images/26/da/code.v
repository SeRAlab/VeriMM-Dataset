module LinkedListTraversal (
    input clk,
    input reset,
    input start,
    output reg [7:0] data_out,
    output reg done
);
    parameter SIZE = 5; // Number of nodes in the linked list
    reg [7:0] linked_list [0:SIZE-1]; // Data storage for linked list nodes
    reg [2:0] current_index; // Current index of the linked list
    initial begin
        // Example data for the linked list
        linked_list[0] = 8'h01;
        linked_list[1] = 8'h02;
        linked_list[2] = 8'h03;
        linked_list[3] = 8'h04;
        linked_list[4] = 8'h05;
        current_index = 3'b000; // Start from the first node
        data_out = 8'h00;
        done = 1'b0;
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_index <= 3'b000;
            data_out <= 8'h00;
            done <= 1'b0;
        end else if (start && !done) begin
            if (current_index < SIZE) begin
                data_out <= linked_list[current_index];
                current_index <= current_index + 1;
            end else begin
                done <= 1'b1; // Mark traversal as done
            end
        end
    end
endmodule