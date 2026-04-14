module binary_max_heap(
    input [7:0] data_in,
    input insert,
    input [2:0] index,
    output reg [7:0] max_out
);
    reg [7:0] heap [0:7];
    integer i;

    always @(*) begin
        if (insert) begin
            heap[index] = data_in;  // Insert new data at the specified index
        end
        max_out = heap[0];  // Assume the first element is the max for simplicity
        for (i = 1; i < 8; i = i + 1) begin
            if (heap[i] > max_out) begin
                max_out = heap[i];  // Find the maximum in the heap
            end
        end
    end
endmodule