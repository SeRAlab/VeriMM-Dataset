module bubble_sort(  
    input [19:0] unsorted, // Concatenated 5 4-bit numbers  
    output reg [19:0] sorted // Concatenated sorted 5 4-bit numbers  
);  
    integer i, j;  
    reg [3:0] temp [4:0];  
  
    always @(*) begin  
        // Unpack the input into a temporary array  
        for (i = 0; i < 5; i = i + 1)  
            temp[i] = unsorted[4*i +: 4];  
  
        // Bubble Sort  
        for (i = 0; i < 5; i = i + 1) begin  
            for (j = 0; j < 4 - i; j = j + 1) begin  
                if (temp[j] > temp[j + 1]) begin  
                    // Swap elements  
                    temp[j] = temp[j] + temp[j + 1];  
                    temp[j + 1] = temp[j] - temp[j + 1];  
                    temp[j] = temp[j] - temp[j + 1];  
                end  
            end  
        end  
  
        // Pack the sorted array back into output  
        sorted = {temp[4], temp[3], temp[2], temp[1], temp[0]};  
    end  
endmodule