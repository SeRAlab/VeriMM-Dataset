module merge_sort(input [31:0] array_in, output reg [31:0] array_out);  
    reg [3:0] temp[7:0];  
    integer i, j, k;  
  
    always @(*) begin  
        // Load input into temporary array  
        for (i = 0; i < 8; i = i + 1)  
            temp[i] = array_in[(i + 1) * 4 - 1 -: 4];  
  
        // Merge sort algorithm  
        for (i = 0; i < 8; i = i + 1) begin  
            for (j = i + 1; j < 8; j = j + 1) begin  
                if (temp[i] > temp[j]) begin  
                    // Swap  
                    temp[i] = temp[i] + temp[j];  
                    temp[j] = temp[i] - temp[j];  
                    temp[i] = temp[i] - temp[j];  
                end  
            end  
        end  
  
        // Load sorted values into output  
        array_out = 0;  
        for (k = 0; k < 8; k = k + 1)  
            array_out[(k + 1) * 4 - 1 -: 4] = temp[k];  
    end  
endmodule