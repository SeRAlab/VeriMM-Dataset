module linked_list_traversal(clk, reset, data_out);  
    input clk;  
    input reset;  
    output reg data_out;  

    reg [4:0] linked_list;  
    reg [2:0] current_index;  

    initial begin  
        linked_list = 5'b10101; // Example linked list values  
        current_index = 3'b000;  
        data_out = 1'b0;  
    end  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            current_index <= 3'b000;  
            data_out <= linked_list[0];  
        end else begin  
            current_index <= current_index + 1;  
            if (current_index < 3'b100) begin  
                data_out <= linked_list[current_index + 1];  
            end  
        end  
    end  
endmodule