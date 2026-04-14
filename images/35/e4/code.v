module binary_heap #(parameter SIZE = 16) (  
    input clk,  
    input reset,  
    input [7:0] data_in,  
    input insert,  
    input delete,  
    output reg [7:0] min_out,  
    output reg [3:0] heap_size  
);  

    reg [7:0] heap [0:SIZE-1];  
    integer i;  

    initial begin  
        heap_size = 0;  
        min_out = 8'hFF;  
    end  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            heap_size <= 0;  
            min_out <= 8'hFF;  
        end else begin  
            if (insert) begin  
                if (heap_size < SIZE) begin  
                    heap[heap_size] <= data_in;  
                    heap_size <= heap_size + 1;  
                    // Call insert function to maintain heap property  
                    // (skipped for brevity)  
                end  
            end  
            if (delete) begin  
                if (heap_size > 0) begin  
                    min_out <= heap[0];  
                    // Call delete function to maintain heap property  
                    // (skipped for brevity)  
                end  
            end  
        end  
    end  
endmodule