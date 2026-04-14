module bubble_sort (
    input [19:0] array_in, // 5 numbers of 4 bits each
    output reg [19:0] array_out
);
    integer i, j;
    reg [3:0] temp;

    always @(*) begin
        array_out = array_in; // Initialize output
        // Bubble Sort algorithm
        for (i = 0; i < 5; i = i + 1) begin
            for (j = 0; j < 5 - i - 1; j = j + 1) begin
                if (array_out[4*j +: 4] > array_out[4*(j + 1) +: 4]) begin
                    // Swap
                    temp = array_out[4*j +: 4];
                    array_out[4*j +: 4] = array_out[4*(j + 1) +: 4];
                    array_out[4*(j + 1) +: 4] = temp;
                end
            end
        end
    end
endmodule