module LinkedListTraversal #(parameter SIZE = 5) (  
    input clk,  
    input [2:0] index,  // 3-bit index for up to 8 elements  
    output reg [15:0] value  
);  
    // Example linked list stored in an array  
    reg [15:0] linked_list [0:SIZE-1];  
    
    // Initialize linked list with some values  
    initial begin  
        linked_list[0] = 16'h0001;  
        linked_list[1] = 16'h0002;  
        linked_list[2] = 16'h0003;  
        linked_list[3] = 16'h0004;  
        linked_list[4] = 16'h0005;  
    end  
    
    always @(posedge clk) begin  
        value <= linked_list[index];  
    end  
endmodule