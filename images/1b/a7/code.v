module rrt_node (
    input wire clk,
    input wire rst_n,
    input wire [7:0] x_in, // X coordinate input
    input wire [7:0] y_in, // Y coordinate input
    input wire add_node,    // Control signal to add a new node
    output reg [7:0] x_out, // X coordinate output of the last added node
    output reg [7:0] y_out, // Y coordinate output of the last added node
    output reg success       // Status signal indicating success
);
    reg [7:0] x_nodes [0:4]; // Array to hold X coordinates of nodes
    reg [7:0] y_nodes [0:4]; // Array to hold Y coordinates of nodes
    integer node_count;      // Counter for the number of nodes

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            node_count <= 0;
            success <= 0;
        end else if (add_node) begin
            if (node_count < 5) begin
                x_nodes[node_count] <= x_in;
                y_nodes[node_count] <= y_in;
                x_out <= x_in;
                y_out <= y_in;
                node_count <= node_count + 1;
                success <= 1; // Node added successfully
            end else begin
                success <= 0; // Failure, node limit reached
            end
        end
    end
endmodule