module linked_list_traversal(clk, reset, head, current_value, end_of_list);  
    input clk;  
    input reset;  
    input [7:0] head;  // Head pointer (8-bit address of the first node)  
    output reg [7:0] current_value;  // Current node value  
    output reg end_of_list;  // Indicates if the end of the list is reached  
    
    reg [7:0] next_node;  // Pointer to the next node  
    reg [7:0] memory [0:255];  // Memory to simulate linked list storage  
    
    // Assume that memory[i] = data for node i and memory[i + 1] = address of the next node  
    initial begin  
        // Sample linked list initialization  
        memory[0] = 8'd10;  // Node 0: data = 10  
        memory[1] = 8'd1;   // Node 0: next = address of Node 1  
        memory[2] = 8'd20;  // Node 1: data = 20  
        memory[3] = 8'd2;   // Node 1: next = address of Node 2  
        memory[4] = 8'd30;  // Node 2: data = 30  
        memory[5] = 8'd0;   // Node 2: next = NULL (end of list)  
    end  
    
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            current_value <= 8'd0;  
            end_of_list <= 1'b0;  
            next_node <= head;  // Start from head  
        end else begin  
            if (next_node == 8'd0) begin  
                end_of_list <= 1'b1;  // End of list  
                current_value <= 8'd0; // Output 0 when end is reached  
            end else begin  
                current_value <= memory[next_node];  // Output current node's data  
                next_node <= memory[next_node + 1];  // Move to the next node  
                end_of_list <= 1'b0;  
            end  
        end  
    end  
endmodule