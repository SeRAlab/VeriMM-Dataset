module quick_sort(input [15:0] array, output reg [15:0] sorted_array);  
    integer i, j;  
    reg [3:0] temp;  
    reg [3:0] arr [0:3];  

    always @(*) begin  
        // Load array into reg array  
        arr[0] = array[3:0];  
        arr[1] = array[7:4];  
        arr[2] = array[11:8];  
        arr[3] = array[15:12];  

        // Quick sort logic using a simple bubble sort for a small array  
        for (i = 0; i < 3; i = i + 1) begin  
            for (j = 0; j < 3 - i; j = j + 1) begin  
                if (arr[j] > arr[j + 1]) begin  
                    // Swap  
                    temp = arr[j];  
                    arr[j] = arr[j + 1];  
                    arr[j + 1] = temp;  
                end  
            end  
        end  

        // Load sorted array into output  
        sorted_array = {arr[3], arr[2], arr[1], arr[0]};  
    end  
endmodule