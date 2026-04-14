module linked_list_traversal (  
    input clk,  
    input reset,  
    output reg [7:0] current_value,  
    output reg end_of_list  
);  
    reg [7:0] linked_list [0:4]; // 5 nodes  
    reg [2:0] current_index; // 3 bits to hold 0-4 index  
    initial begin  
        // Initializing linked list with sample values and next pointers  
        linked_list[0] = 8'h01; // Node 0  
        linked_list[1] = 8'h02; // Node 1  
        linked_list[2] = 8'h03; // Node 2  
        linked_list[3] = 8'h04; // Node 3  
        linked_list[4] = 8'h00; // End of list indicator (0)  
    end  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            current_index <= 0;  
            current_value <= 8'h00;  
            end_of_list <= 1'b0;  
        end else if (current_index < 5) begin  
            current_value <= linked_list[current_index];  
            if (linked_list[current_index] == 8'h00) begin  
                end_of_list <= 1'b1;  
            end else begin  
                current_index <= current_index + 1;  
                end_of_list <= 1'b0;  
            end  
        end  
    end  
endmodule