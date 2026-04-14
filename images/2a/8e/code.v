module linked_list_traversal (
    input clk,
    input reset,
    input [31:0] start_addr,
    output reg [31:0] node_value,
    output reg done
);
    // Define the linked list nodes in a memory array for simulation
    reg [31:0] memory [0:15]; // Assume a maximum of 16 nodes
    reg [31:0] next_ptr [0:15]; // Next pointer array
    reg [3:0] current_node;

    initial begin
        // Initialize the linked list nodes (example)
        memory[0] = 10; next_ptr[0] = 4; // Node 0 points to Node 1
        memory[1] = 20; next_ptr[1] = 8; // Node 1 points to Node 2
        memory[2] = 30; next_ptr[2] = 12; // Node 2 points to Node 3
        memory[3] = 40; next_ptr[3] = 0; // Node 3 points to null
        // Initialize the rest to 0 if necessary
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_node <= 0;
            node_value <= 0;
            done <= 0;
        end else begin
            if (current_node == 0 && start_addr != 0) begin
                current_node <= start_addr[3:0]; // Start traversal from the given address
            end

            if (current_node != 0) begin
                node_value <= memory[current_node];
                current_node <= next_ptr[current_node];
                if (current_node == 0) begin
                    done <= 1; // Traversal is done
                end
            end else begin
                done <= 1; // No valid start address
            end
        end
    end
endmodule