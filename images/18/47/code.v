module linked_list_traversal(input clk, reset, input [3:0] index, output reg [7:0] value);  
    reg [7:0] linked_list [0:15];  
    reg [3:0] current_index;  
    initial begin  
        // Initialize the linked list with some values  
        linked_list[0] = 8'd10;  
        linked_list[1] = 8'd20;  
        linked_list[2] = 8'd30;  
        linked_list[3] = 8'd40;  
        linked_list[4] = 8'd0;  // End of list indicator  
        // rest of the array initialized to 0  
        linked_list[5] = 8'd0;  
        linked_list[6] = 8'd0;  
        linked_list[7] = 8'd0;  
        linked_list[8] = 8'd0;  
        linked_list[9] = 8'd0;  
        linked_list[10] = 8'd0;  
        linked_list[11] = 8'd0;  
        linked_list[12] = 8'd0;  
        linked_list[13] = 8'd0;  
        linked_list[14] = 8'd0;  
        linked_list[15] = 8'd0;  
    end  
      
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            current_index <= 0;  
            value <= 8'd0;  
        end else begin  
            if (linked_list[current_index] != 8'd0) begin  
                value <= linked_list[current_index];  
                current_index <= current_index + 1;  
            end else begin  
                value <= 8'd0;  // End of list reached  
            end  
        end  
    end  
endmodule