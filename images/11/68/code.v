module merge_sort (
    input [3:0] array1,
    input [3:0] array2,
    output [7:0] merged_array
);
    wire [3:0] sorted_array1;
    wire [3:0] sorted_array2;
    
    assign sorted_array1 = {array1[3], array1[2], array1[1], array1[0]};
    assign sorted_array2 = {array2[3], array2[2], array2[1], array2[0]};
    
    assign merged_array[7:0] = {sorted_array1, sorted_array2}; // Simplified merge for demo purposes

endmodule