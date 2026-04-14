module rnn(
    input clk,
    input reset,
    input [3:0] x, // 4-bit input
    output reg [3:0] y // 4-bit output
);
    reg [3:0] prev_y; // store previous output

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            prev_y <= 4'b0000; // reset previous output
            y <= 4'b0000; // reset output
        end else begin
            // Implement a simple RNN logic
            y <= (prev_y + x) ^ 4'b1010; // example operation
            prev_y <= y; // update previous output
        end
    end
endmodule