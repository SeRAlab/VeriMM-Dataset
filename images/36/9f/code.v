module LinkedListTraversal(  
    input clk,  
    input rst,  
    input [3:0] index,  // Input index to start traversal  
    output reg [7:0] current_value,  // Current node value  
    output reg done  // Signal to indicate traversal completion  
);  
    reg [7:0] linked_list [0:15];  // Example linked list with 16 nodes  
    reg [3:0] ptr;  // Pointer to the current node  

    // Initialize the linked list (for simplicity, we use just numbers)  
    initial begin  
        linked_list[0] = 8'h01;  
        linked_list[1] = 8'h02;  
        linked_list[2] = 8'h03;  
        linked_list[3] = 8'h04;  
        linked_list[4] = 8'h05;  
        linked_list[5] = 8'h06;  
        linked_list[6] = 8'h07;  
        linked_list[7] = 8'h08;  
        linked_list[8] = 8'h09;  
        linked_list[9] = 8'h0A;  
        linked_list[10] = 8'h0B;  
        linked_list[11] = 8'h0C;  
        linked_list[12] = 8'h0D;  
        linked_list[13] = 8'h0E;  
        linked_list[14] = 8'h0F;  
        linked_list[15] = 8'h00;  // End of the list (0 indicates end)  
    end  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            ptr <= 0;  
            current_value <= 8'h00;  
            done <= 0;  
        end else if (ptr < 16) begin  
            if (index == ptr) begin  
                current_value <= linked_list[ptr];  
                ptr <= ptr + 1;  
                if (linked_list[ptr] == 8'h00) // Check for end of list  
                    done <= 1;  
            end  
        end  
    end  
endmodule