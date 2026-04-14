module linked_list_traversal(  
    input clk,  
    input rst,  
    input [4:0] head,  
    output reg [4:0] current_value  
);  
    reg [4:0] list [0:9]; // Array to represent linked list  
    reg [3:0] pointer; // Pointer to current node index  

    initial begin  
        // Example initialization of linked list  
        list[0] = 5'd1;  
        list[1] = 5'd2;  
        list[2] = 5'd3;  
        list[3] = 5'd4;  
        list[4] = 5'd5;  
        list[5] = 5'd0;  
        list[6] = 5'd0;  
        list[7] = 5'd0;  
        list[8] = 5'd0;  
        list[9] = 5'd0;  
        pointer = 0; // Start at the head of the list  
    end  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            pointer <= 0;  
            current_value <= list[0];  
        end else if (pointer < 5) begin  
            current_value <= list[pointer];  
            pointer <= pointer + 1;  
        end  
    end  
endmodule