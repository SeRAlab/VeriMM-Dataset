module merge_sort(
    input [3:0] in_array,
    output reg [3:0] sorted_array
);

always @(*) begin
    // Initialize the sorted array
    sorted_array = in_array;

    // Sort the array using a simple comparison method
    if (sorted_array[0] > sorted_array[1]) begin
        {sorted_array[0], sorted_array[1]} = {sorted_array[1], sorted_array[0]};
    end
    if (sorted_array[0] > sorted_array[2]) begin
        {sorted_array[0], sorted_array[2]} = {sorted_array[2], sorted_array[0]};
    end
    if (sorted_array[0] > sorted_array[3]) begin
        {sorted_array[0], sorted_array[3]} = {sorted_array[3], sorted_array[0]};
    end
    if (sorted_array[1] > sorted_array[2]) begin
        {sorted_array[1], sorted_array[2]} = {sorted_array[2], sorted_array[1]};
    end
    if (sorted_array[1] > sorted_array[3]) begin
        {sorted_array[1], sorted_array[3]} = {sorted_array[3], sorted_array[1]};
    end
    if (sorted_array[2] > sorted_array[3]) begin
        {sorted_array[2], sorted_array[3]} = {sorted_array[3], sorted_array[2]};
    end
end

endmodule