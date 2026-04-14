module fir_filter (
    input [3:0] x, // 4-bit input signal
    input clk,
    output reg [7:0] y // 8-bit output signal to accommodate sum
);
    reg [3:0] buffer[0:3]; // 4-tap buffer
    integer i;

    always @(posedge clk) begin
        // Shift the input data into the buffer
        buffer[3] <= buffer[2];
        buffer[2] <= buffer[1];
        buffer[1] <= buffer[0];
        buffer[0] <= x;
    end

    always @(*) begin
        // Calculate the output using the coefficients [1, 2, 3, 4]
        y = (buffer[0] * 1) + (buffer[1] * 2) + (buffer[2] * 3) + (buffer[3] * 4);
    end
endmodule