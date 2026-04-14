module binary_search(input [4:0] arr0, input [4:0] arr1, input [4:0] arr2, input [4:0] arr3, input [4:0] arr4, input [2:0] search_val, output reg found);  
    always @(*) begin  
        found = 0;  
        if (arr0 == search_val) found = 1;  
        else if (arr1 == search_val) found = 1;  
        else if (arr2 == search_val) found = 1;  
        else if (arr3 == search_val) found = 1;  
        else if (arr4 == search_val) found = 1;  
    end  
endmodule