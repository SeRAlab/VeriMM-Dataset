module bubble_sort(  
    input [19:0] arr_in, // 5 numbers of 4 bits each  
    output reg [19:0] arr_out // sorted output  
);  
    integer i, j;  
    reg [3:0] temp;  
    reg [4:0] arr [4:0];  

    always @(*) begin  
        // Initialize the array from the input  
        for (i = 0; i < 5; i = i + 1)  
            arr[i] = arr_in[4*i +: 4];  

        // Bubble sort algorithm  
        for (i = 0; i < 4; i = i + 1) begin  
            for (j = 0; j < 4 - i; j = j + 1) begin  
                if (arr[j] > arr[j + 1]) begin  
                    // Swap  
                    temp = arr[j];  
                    arr[j] = arr[j + 1];  
                    arr[j + 1] = temp;  
                end  
            end  
        end  

        // Assign sorted values to output  
        for (i = 0; i < 5; i = i + 1)  
            arr_out[4*i +: 4] = arr[i];  
    end  
endmodule