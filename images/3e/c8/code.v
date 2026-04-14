module bubble_sort (
    input [3:0] in_array,
    output reg [3:0] out_array
);
    integer i, j;
    reg [3:0] temp;

    always @(*) begin
        out_array = in_array; // Copy input to output
        for (i = 0; i < 4; i = i + 1) begin
            for (j = 0; j < 4 - i - 1; j = j + 1) begin
                if (out_array[j] > out_array[j + 1]) begin
                    temp = out_array[j];
                    out_array[j] = out_array[j + 1];
                    out_array[j + 1] = temp;
                end
            end
        end
    end
endmodule