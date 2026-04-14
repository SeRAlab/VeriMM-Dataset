module linked_list_traversal(
    input wire clk,
    input wire reset,
    output reg [7:0] current_value,
    output reg done
);
    reg [7:0] linked_list [0:4]; // Example linked list with 5 nodes
    reg [2:0] index; // Index for the current node

    initial begin
        linked_list[0] = 8'h01; // Node 1
        linked_list[1] = 8'h02; // Node 2
        linked_list[2] = 8'h03; // Node 3
        linked_list[3] = 8'h04; // Node 4
        linked_list[4] = 8'hFF; // End marker
        index = 0;
        current_value = 8'h00;
        done = 1'b0;
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            index <= 0;
            current_value <= 8'h00;
            done <= 1'b0;
        end else if (index < 5) begin
            current_value <= linked_list[index];
            if (linked_list[index] == 8'hFF) begin
                done <= 1'b1; // Mark as done if end marker encountered
            end else begin
                index <= index + 1; // Move to the next node
            end
        end
    end
endmodule