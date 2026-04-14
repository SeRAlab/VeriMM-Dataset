module merge_sort(
    input clk,
    input start,
    input [31:0] data_in, // 8 4-bit numbers
    output reg [31:0] data_out, // sorted 8 4-bit numbers
    output reg done
);
    reg [3:0] arr [7:0]; // Array of 8 4-bit numbers
    reg [2:0] state, next_state;
    integer i, j;
    
    initial begin
        done = 0;
        state = 0;
    end

    always @(posedge clk) begin
        if (start) begin
            for (i = 0; i < 8; i = i + 1) begin
                arr[i] <= data_in[i*4 +: 4];
            end
            state <= 1; // Go to sorting state
        end else if (state == 1) begin
            // Merge Sort Logic
            // Simplified for illustration; implement a full merge sort in practice
            for (i = 0; i < 7; i = i + 1) begin
                for (j = 0; j < 7 - i; j = j + 1) begin
                    if (arr[j] > arr[j+1]) begin
                        {arr[j], arr[j+1]} <= {arr[j+1], arr[j]};
                    end
                end
            end
            state <= 2; // Go to done state
        end else if (state == 2) begin
            for (i = 0; i < 8; i = i + 1) begin
                data_out[i*4 +: 4] <= arr[i];
            end
            done <= 1; // Sorting done
            state <= 0; // Reset state
        end
    end
endmodule