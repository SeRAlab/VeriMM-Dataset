module BST(input clk,  
           input [31:0] data,  
           input ctrl, // 0 for insert, 1 for search  
           output reg found);  

    // Node structure  
    reg [31:0] node_data;  
    reg left_child_present;  
    reg right_child_present;  
    reg [31:0] left_child;  
    reg [31:0] right_child;  

    initial begin  
        node_data = 0;  
        left_child_present = 0;  
        right_child_present = 0;  
        left_child = 0;  
        right_child = 0;  
        found = 0;  
    end  

    always @(posedge clk) begin  
        if (ctrl == 0) begin // Insert  
            if (node_data == 0) begin  
                node_data <= data;  
            end else if (data < node_data) begin  
                left_child_present <= 1;  
                left_child <= data;  
            end else begin  
                right_child_present <= 1;  
                right_child <= data;  
            end  
        end else if (ctrl == 1) begin // Search  
            if (data == node_data) begin  
                found <= 1;  
            end else if (data < node_data && left_child_present == 1 && data == left_child) begin  
                found <= 1;  
            end else if (data > node_data && right_child_present == 1 && data == right_child) begin  
                found <= 1;  
            end else begin  
                found <= 0;  
            end  
        end  
    end  
endmodule