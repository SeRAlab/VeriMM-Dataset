module linked_list_traversal #(
    parameter DATA_WIDTH = 8
) (
    input clk,
    input reset,
    input [DATA_WIDTH-1:0] data_in, // Data for the current node
    input [DATA_WIDTH-1:0] next_node, // Pointer to the next node
    output reg [DATA_WIDTH-1:0] current_value // Current node value output
);  
    reg [DATA_WIDTH-1:0] current_node; // Register to hold current node pointer

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            current_value <= 0;  
            current_node <= 0;  
        end else if (current_node != 0) begin  
            current_value <= data_in;  
            current_node <= next_node;  
        end  
    end  
endmodule