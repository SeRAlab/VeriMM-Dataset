module bubble_sort(input [19:0] data_in, output reg [19:0] data_out);  
    integer i, j;  
    reg [3:0] temp;  
    reg [19:0] arr;  
    
    always @* begin  
        arr = data_in;  
        for (i = 0; i < 5; i = i + 1) begin  
            for (j = 0; j < 4 - i; j = j + 1) begin  
                if (arr[j*4 +: 4] > arr[(j+1)*4 +: 4]) begin  
                    temp = arr[j*4 +: 4];  
                    arr[j*4 +: 4] = arr[(j+1)*4 +: 4];  
                    arr[(j+1)*4 +: 4] = temp;  
                end  
            end  
        end  
        data_out = arr;  
    end  
endmodule