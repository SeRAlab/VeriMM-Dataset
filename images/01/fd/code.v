module fir_filter (
    input wire clk,
    input wire [4:0] x, // 5-bit input data
    output reg [4:0] y  // 5-bit output data
);
    reg [4:0] delay [0:4]; // 5-tap delay line
    integer i;

    always @(posedge clk) begin
        // Shift the delay line
        for (i = 4; i > 0; i = i - 1) begin
            delay[i] <= delay[i - 1];
        end
        delay[0] <= x; // Store current input in delay line

        // Compute output
        y <= (delay[0] * 1 + delay[1] * 2 + delay[2] * 3 + delay[3] * 2 + delay[4] * 1);
    end
endmodule