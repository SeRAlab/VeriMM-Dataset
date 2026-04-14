module linked_list_traversal(  
    input clk,  
    input reset,  
    input advance,  
    input [3:0] node_value,  
    output reg [3:0] current_value,  
    output reg end_of_list  
);  
    reg [1:0] state;  
    reg [3:0] list [0:3]; // Simple linked list with 4 nodes  
    reg [1:0] current_node;  
  
    initial begin  
        list[0] = 4'b0001; // Node 0  
        list[1] = 4'b0010; // Node 1  
        list[2] = 4'b0100; // Node 2  
        list[3] = 4'b1000; // Node 3  
        current_node = 0;  
        end_of_list = 0;  
    end  
  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            current_node <= 0;  
            current_value <= 0;  
            end_of_list <= 0;  
        end else if (advance) begin  
            if (current_node < 3) begin  
                current_value <= list[current_node];  
                current_node <= current_node + 1;  
            end else begin  
                current_value <= list[current_node];  
                end_of_list <= 1; // End of list reached  
            end  
        end  
    end  
endmodule