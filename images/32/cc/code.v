module linked_list_traversal (
    input [2:0] index, // Assuming a 3-bit index for the linked list with 8 nodes
    output reg [7:0] node_value // 8-bit output for node value
);
    // Define the linked list values
    reg [7:0] linked_list [0:7]; // Array to represent linked list values

    initial begin
        linked_list[0] = 8'h01; // Node 0 value
        linked_list[1] = 8'h02; // Node 1 value
        linked_list[2] = 8'h03; // Node 2 value
        linked_list[3] = 8'h04; // Node 3 value
        linked_list[4] = 8'h05; // Node 4 value
        linked_list[5] = 8'h06; // Node 5 value
        linked_list[6] = 8'h07; // Node 6 value
        linked_list[7] = 8'h08; // Node 7 value
    end

    always @(*) begin
        node_value = linked_list[index]; // Traverse the list based on index
    end
endmodule