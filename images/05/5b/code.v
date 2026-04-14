module binary_search_comparator(  
    input [3:0] target,  
    input [3:0] index,  
    output reg found  
);  
    reg [3:0] array [0:15];  
    initial begin  
        // Initialize the array with some values for testing purposes  
        array[0] = 4'b0000;  
        array[1] = 4'b0001;  
        array[2] = 4'b0010;  
        array[3] = 4'b0011;  
        array[4] = 4'b0100;  
        array[5] = 4'b0101;  
        array[6] = 4'b0110;  
        array[7] = 4'b0111;  
        array[8] = 4'b1000;  
        array[9] = 4'b1001;  
        array[10] = 4'b1010;  
        array[11] = 4'b1011;  
        array[12] = 4'b1100;  
        array[13] = 4'b1101;  
        array[14] = 4'b1110;  
        array[15] = 4'b1111;  
    end  

    always @(*) begin  
        found = (array[index] == target);  
    end  
endmodule