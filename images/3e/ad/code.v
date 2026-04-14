module binary_search(  
    input [4:0] search_value,  
    output reg found  
);  
    reg [4:0] sorted_array [0:4];  
    integer i;  
   
    initial begin  
        sorted_array[0] = 5'b00000;  
        sorted_array[1] = 5'b00001;  
        sorted_array[2] = 5'b00010;  
        sorted_array[3] = 5'b00011;  
        sorted_array[4] = 5'b00100;  
    end  
   
    always @(*) begin  
        found = 0;  
        for (i = 0; i < 5; i = i + 1) begin  
            if (search_value == sorted_array[i]) begin  
                found = 1;  
            end  
        end  
    end  
endmodule