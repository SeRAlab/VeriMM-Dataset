module max_heap(  
    input wire [7:0] insert_value,  
    input wire insert,  
    output reg [7:0] max_value,  
    output reg valid  
);  
    reg [7:0] heap [0:15];  
    reg [3:0] size;  

    always @(*) begin  
        max_value = 8'b0;  
        valid = 1'b0;  
        if (size > 0) begin  
            max_value = heap[0];  
            valid = 1'b1;  
        end  
    end  

    always @(posedge insert) begin  
        if (size < 16) begin  
            heap[size] = insert_value;  
            size = size + 1;  
            // Heapify up logic would go here, simplified for this example  
        end  
    end  
endmodule