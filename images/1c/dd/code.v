module rnn_cell (
    input clk,
    input rst,
    input [1:0] x,        // 2-bit input
    output reg [1:0] y    // 2-bit output
);
    reg [1:0] prev_y;     // Previous output

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            prev_y <= 2'b00;
            y <= 2'b00;
        end else begin
            prev_y <= y;             // Store current output as previous output
            y <= (prev_y + x) % 4;   // Calculate new output
        end
    end
endmodule