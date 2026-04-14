module bubble_sort (
    input clk,
    input reset,
    input start,
    input [15:0] data_in,   // 4 elements of 4-bit numbers
    output reg [15:0] data_out, // sorted output, 4 elements of 4-bit numbers
    output reg done
);
    reg [3:0] arr [0:3]; // Array to hold 4 elements
    reg [1:0] i, j;
    reg swapping;
    
    initial begin
        done = 0;
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            arr[0] <= 0;
            arr[1] <= 0;
            arr[2] <= 0;
            arr[3] <= 0;
            data_out <= 0;
            done <= 0;
            swapping <= 0;
            i <= 0;
            j <= 0;
        end else if (start) begin
            arr[0] <= data_in[15:12];
            arr[1] <= data_in[11:8];
            arr[2] <= data_in[7:4];
            arr[3] <= data_in[3:0];
            i <= 0;
            j <= 0;
            done <= 0;
            swapping <= 1;
        end else if (swapping) begin
            if (j < 3 - i) begin
                if (arr[j] > arr[j + 1]) begin
                    {arr[j], arr[j + 1]} <= {arr[j + 1], arr[j]}; // Swap
                end
                j <= j + 1;
            end else if (i < 3) begin
                i <= i + 1;
                j <= 0;
            end else begin
                done <= 1;
                swapping <= 0;
                data_out <= {arr[0], arr[1], arr[2], arr[3]};
            end
        end
    end
endmodule