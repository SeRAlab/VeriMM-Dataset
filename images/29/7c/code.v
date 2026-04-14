module rnn_cell (
    input clk,
    input rst,
    input [3:0] x,        // Input
    output reg [3:0] h,   // Hidden state
    output reg [3:0] y     // Output
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            h <= 4'b0000;  // Reset hidden state
            y <= 4'b0000;  // Reset output
        end else begin
            y <= x + h;    // Output is the sum of input and hidden state
            h <= y;        // Next hidden state is the output
        end
    end
endmodule