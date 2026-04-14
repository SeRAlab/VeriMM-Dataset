module heap_sort (input [3:0] A, B, C, D, output [3:0] S0, S1, S2, S3);  
    wire [3:0] input_array[3:0];  
    assign input_array[0] = A;  
    assign input_array[1] = B;  
    assign input_array[2] = C;  
    assign input_array[3] = D;  

    function [3:0] max;  
        input [3:0] x, y;  
        begin  
            max = (x > y) ? x : y;  
        end  
    endfunction  

    function [3:0] min;  
        input [3:0] x, y;  
        begin  
            min = (x < y) ? x : y;  
        end  
    endfunction  

    wire [3:0] tmp0, tmp1;  
    wire [3:0] tmp2, tmp3;  

    assign tmp0 = max(input_array[0], input_array[1]);  
    assign tmp1 = min(input_array[0], input_array[1]);  
    assign tmp2 = max(input_array[2], input_array[3]);  
    assign tmp3 = min(input_array[2], input_array[3]);  

    assign S3 = max(tmp0, tmp2);  
    assign S0 = min(tmp1, tmp3);  

    wire [3:0] mid1, mid2;  
    assign mid1 = min(tmp0, tmp2);  
    assign mid2 = max(tmp1, tmp3);  

    assign S1 = min(mid1, mid2);  
    assign S2 = max(mid1, mid2);  
endmodule