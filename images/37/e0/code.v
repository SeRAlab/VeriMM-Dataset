module binary_search (
    input [4:0] array,  // 5-bit input representing a sorted array of 5 elements
    input [2:0] index,  // 3-bit input to specify the index to search for
    output reg found     // 1-bit output indicating if the element is found
);
    always @(*) begin
        if (array[index] == 1'b1) // Check if the specific index in the array is 1
            found = 1'b1;          // Element found
        else
            found = 1'b0;          // Element not found
    end
endmodule