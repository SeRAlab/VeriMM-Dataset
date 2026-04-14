module binary_search (  
    input [15:0] input_array,  
    input [3:0] target,  
    output reg found  
);  
    integer i;  
    always @(*) begin  
        found = 0;  
        for (i = 0; i < 4; i = i + 1) begin  
            if (input_array[4*i +: 4] == target) begin  
                found = 1;  
            end  
        end  
    end  
endmodule