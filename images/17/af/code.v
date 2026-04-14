module quick_sort(input [63:0] array_in,  
                  input start,  
                  output reg [63:0] array_out);  
  
    reg [7:0] array [0:7];  
    integer i, j;  
  
    always @(*) begin  
        if (start) begin  
            // Load input array  
            for (i = 0; i < 8; i = i + 1)  
                array[i] = array_in[8*i +: 8];  
  
            // Quick Sort Implementation  
            for (i = 0; i < 7; i = i + 1) begin  
                for (j = 0; j < 7 - i; j = j + 1) begin  
                    if (array[j] > array[j + 1]) begin  
                        // Swap  
                        {array[j], array[j + 1]} = {array[j + 1], array[j]};  
                    end  
                end  
            end  
  
            // Load sorted array to output  
            array_out = 0;  
            for (i = 0; i < 8; i = i + 1)  
                array_out[8*i +: 8] = array[i];  
        end else begin  
            array_out = array_out;  
        end  
    end  
endmodule