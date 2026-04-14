module linked_list_traversal(  
    input clk,  
    input [7:0] head,  
    output reg [7:0] current_data  
);  
    reg [7:0] current_node;  
    reg [7:0] next_node;  

    always @(posedge clk) begin  
        current_node <= head;  
        current_data <= current_node;  
        // Assume the next_node is obtained from the current_node (for simplicity)  
        next_node <= current_node + 1; // Example for moving to the next node  
        current_node <= next_node;  
    end  
endmodule