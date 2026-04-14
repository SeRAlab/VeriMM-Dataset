module bubble_sort(input [31:0] array_in, output reg [31:0] array_out);  
    integer i, j;  
    reg [7:0] temp [3:0];  
    reg [7:0] data [3:0];  

    always @(*) begin  
        // Unpack the input into the data array  
        for (i = 0; i < 4; i = i + 1) begin  
            data[i] = array_in[8*i +: 8];  
        end  

        // Perform bubble sort  
        for (i = 0; i < 4; i = i + 1) begin  
            for (j = 0; j < 3 - i; j = j + 1) begin  
                if (data[j] > data[j + 1]) begin  
                    temp[j] = data[j];  
                    data[j] = data[j + 1];  
                    data[j + 1] = temp[j];  
                end  
            end  
        end  

        // Pack the sorted data back into the output array  
        for (i = 0; i < 4; i = i + 1) begin  
            array_out[8*i +: 8] = data[i];  
        end  
    end  
endmodule