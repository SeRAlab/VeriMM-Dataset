module linked_list_traversal(  
    input clk,  
    input reset,  
    input [3:0] index_in,  
    output reg [7:0] current_element  
);  
    reg [7:0] linked_list [0:15];  
    reg [3:0] current_index;  

    initial begin  
        // Initializing the linked list with some values  
        linked_list[0] = 8'h01;  
        linked_list[1] = 8'h02;  
        linked_list[2] = 8'h03;  
        linked_list[3] = 8'h04;  
        linked_list[4] = 8'h05;  
        linked_list[5] = 8'h06;  
        linked_list[6] = 8'h07;  
        linked_list[7] = 8'h08;  
        linked_list[8] = 8'h09;  
        linked_list[9] = 8'h0A;  
        linked_list[10] = 8'h0B;  
        linked_list[11] = 8'h0C;  
        linked_list[12] = 8'h0D;  
        linked_list[13] = 8'h0E;  
        linked_list[14] = 8'h0F;  
        linked_list[15] = 8'h10;  
    end  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            current_index <= 4'b0000;  
            current_element <= linked_list[current_index];  
        end else begin  
            current_index <= index_in;  
            current_element <= linked_list[current_index];  
        end  
    end  
endmodule