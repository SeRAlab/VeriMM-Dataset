module cnn_convolution (
    input wire clk,
    input wire reset,
    input wire [24:0] input_data, // 5x5 input feature map flattened
    input wire [8:0] kernel, // 3x3 kernel flattened
    output reg [15:0] output_data // 1 output value
);
    
    reg [2:0] row, col;
    reg [15:0] sum;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            output_data <= 0;
            sum <= 0;
            row <= 0;
            col <= 0;
        end else begin
            if (row < 3 && col < 3) begin
                sum <= sum + (input_data[(row * 5 + col)] * kernel[(row * 3 + col)]);
                col <= col + 1;
                if (col == 2) begin
                    col <= 0;
                    row <= row + 1;
                end
            end else begin
                output_data <= sum;
                row <= 0;
                col <= 0;
                sum <= 0; // reset for next convolution
            end
        end
    end
endmodule