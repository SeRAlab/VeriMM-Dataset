module binary_search(input [3:0] target, input [15:0] array, output reg [3:0] index);  
    integer i;  
    always @(*) begin  
        index = 4'b1111; // Default to not found  
        for (i = 0; i < 4; i = i + 1) begin  
            if (array[i*4 +: 4] == target) begin  
                index = i;  
            end  
        end  
    end  
endmodule