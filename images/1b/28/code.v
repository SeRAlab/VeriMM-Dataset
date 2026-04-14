module linked_list_traversal(
    input clk,
    input reset,
    input [31:0] head,
    output reg [31:0] current_value,
    output reg done
);
    reg [31:0] list[0:31]; // Assuming a maximum of 32 nodes
    reg [31:0] current_node;

    initial begin
        // Sample initialization of the linked list
        list[0] = 10; // Node 0
        list[1] = 20; // Node 1
        list[2] = 30; // Node 2
        list[3] = -1; // End of list indicator
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_node <= head;
            current_value <= 0;
            done <= 0;
        end else if (current_node != 32'hFFFFFFFF) begin
            current_value <= list[current_node];
            if (list[current_node] == -1) begin
                done <= 1; // Indicate the end of the list
                current_node <= 32'hFFFFFFFF; // Stop traversing
            end else begin
                current_node <= current_node + 1; // Move to next node
                done <= 0;
            end
        end
    end
endmodule