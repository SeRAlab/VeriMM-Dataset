module linked_list_traversal (
    input clk,
    input rst,
    input [7:0] in_data,
    input insert,
    output reg [7:0] out_data,
    output reg valid
);  
    parameter MAX_NODES = 5;  
    reg [7:0] list [0:MAX_NODES-1];  
    reg [2:0] head;  
    reg [2:0] count;  
    
    initial begin  
        head = 0;  
        count = 0;  
        valid = 0;  
    end  
    
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            head <= 0;  
            count <= 0;  
            valid <= 0;  
        end else if (insert && count < MAX_NODES) begin  
            list[head] <= in_data;  
            head <= head + 1;  
            count <= count + 1;  
            valid <= 0;  
        end else if (count > 0) begin  
            out_data <= list[MAX_NODES - count];  
            valid <= 1;  
            count <= count - 1;  
        end else begin  
            valid <= 0;  
        end  
    end  
endmodule