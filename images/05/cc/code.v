module linked_list_traversal #(parameter NODE_COUNT = 5) (  
    input clk,  
    input rst,  
    input [4:0] head,  
    input traverse,  
    output reg [4:0] current_value  
);  
    reg [4:0] linked_list [0:NODE_COUNT-1];  
    reg [2:0] current_node;  

    initial begin  
        linked_list[0] = 5'd1;  
        linked_list[1] = 5'd2;  
        linked_list[2] = 5'd3;  
        linked_list[3] = 5'd4;  
        linked_list[4] = 5'd5;  
        current_node = 3'd0;  
    end  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            current_node <= 3'd0;  
            current_value <= linked_list[current_node];  
        end else if (traverse) begin  
            if (current_node < NODE_COUNT - 1)  
                current_node <= current_node + 1;  
            current_value <= linked_list[current_node];  
        end  
    end  
endmodule