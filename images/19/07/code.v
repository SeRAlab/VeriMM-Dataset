module LinkedList(input clk, input reset, input [7:0] data_in, input insert, output reg [7:0] data_out, output reg valid);  
    parameter MAX_NODES = 5;  
    reg [7:0] list [0:MAX_NODES-1];  
    reg [2:0] head;  
    reg [2:0] count;  
    reg [2:0] current_node;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            head <= 0;  
            count <= 0;  
            current_node <= 0;  
            valid <= 0;  
        end else begin  
            if (insert && count < MAX_NODES) begin  
                list[count] <= data_in;  
                count <= count + 1;  
            end  
            if (current_node < count) begin  
                data_out <= list[current_node];  
                valid <= 1;  
                current_node <= current_node + 1;  
            end else begin  
                valid <= 0;  
                current_node <= 0;  
            end  
        end  
    end  
endmodule