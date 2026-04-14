module bst(clk, reset, insert, search, value, found, tree_value);  
    input clk, reset, insert, search;  
    input [7:0] value;  
    output reg found;  
    output reg [7:0] tree_value;  

    parameter IDLE = 2'b00, INSERTING = 2'b01, SEARCHING = 2'b10;  
    reg [1:0] state, next_state;  
    reg [7:0] node_value;  
    reg left_child, right_child;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= IDLE;  
            found <= 0;  
        end else begin  
            state <= next_state;  
        end  
    end  

    always @(state or insert or search or value) begin  
        case (state)  
            IDLE: begin  
                if (insert) begin  
                    next_state = INSERTING;  
                    node_value = value;  
                end else if (search) begin  
                    next_state = SEARCHING;  
                end else begin  
                    next_state = IDLE;  
                end  
                found = 0;  
            end  
            INSERTING: begin  
                // Insert the value into the BST  
                // This is a simplified example for testing, not a full BST implementation  
                if (value < node_value) begin  
                    left_child = 1;  
                end else if (value > node_value) begin  
                    right_child = 1;  
                end else begin  
                    node_value = value; // Duplicate value, do nothing  
                end  
                next_state = IDLE;  
            end  
            SEARCHING: begin  
                // Search for the value in the BST  
                if (value == node_value) begin  
                    found = 1;  
                    tree_value = node_value;  
                end  
                next_state = IDLE;  
            end  
        endcase  
    end  
endmodule