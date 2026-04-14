module linked_list_traversal(  
    input clk,  
    input reset,  
    input [7:0] head,  
    output reg [7:0] current_value,  
    output reg done  
);  
    reg [7:0] current_node;  
    reg [7:0] next_node;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            current_value <= 8'b0;  
            current_node <= head;  
            done <= 1'b0;  
        end else if (current_node != 8'b0) begin  
            current_value <= current_node;  
            // Assuming the current_node value holds the next pointer in the upper bits  
            // and the value is in the lower bits  
            next_node <= current_node[7:0];  
            current_node <= next_node;  
        end else begin  
            done <= 1'b1;  
        end  
    end  
endmodule