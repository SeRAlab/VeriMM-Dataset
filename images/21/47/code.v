module linked_list_traversal #(parameter N = 5) (  
    input wire clk,  
    input wire reset,  
    input wire [2:0] index,  // 3 bits can represent indices 0 to 7  
    output reg [7:0] data_out  // 8-bit data output  
);  
    // Linked list represented as an array of registers  
    reg [7:0] linked_list [0:N-1];  
    integer i;  

    initial begin  
        // Initializing the linked list with some values  
        for (i = 0; i < N; i = i + 1)  
            linked_list[i] = i + 1;  // Example values: 1, 2, 3, ...  
    end  

    always @(posedge clk or posedge reset) begin  
        if (reset)  
            data_out <= 8'b0;  
        else if (index < N)  
            data_out <= linked_list[index];  
        else  
            data_out <= 8'b0;  // Out of bounds  
    end  
endmodule