module bubble_sort (
    input clk,
    input start,
    input [31:0] data_in, // 4 inputs of 8-bit each
    output reg [31:0] sorted_data,
    output reg done
);
    reg [7:0] array [3:0]; // 4 elements of 8-bit
    reg [1:0] i, j;
    reg swapping;
    
    always @(posedge clk) begin
        if (start) begin
            array[0] <= data_in[7:0];
            array[1] <= data_in[15:8];
            array[2] <= data_in[23:16];
            array[3] <= data_in[31:24];
            done <= 0;
            i <= 0;
            j <= 0;
            swapping <= 1;
        end
        else if (swapping) begin
            if (j < 3 - i) begin
                if (array[j] > array[j + 1]) begin
                    // swap
                    {array[j], array[j + 1]} <= {array[j + 1], array[j]};
                end
                j <= j + 1;
            end else if (i < 3) begin
                i <= i + 1;
                j <= 0;
            end else begin
                swapping <= 0;
                sorted_data <= {array[3], array[2], array[1], array[0]};
                done <= 1;
            end
        end
    end
endmodule