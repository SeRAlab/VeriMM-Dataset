module rnn_inference (
    input wire clk,
    input wire rst,
    input wire [7:0] x,          // Input vector
    output reg [7:0] y           // Output vector
);
    reg [7:0] h;                 // Hidden state

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            h <= 8'b0;           // Reset hidden state
            y <= 8'b0;           // Reset output
        end else begin
            h <= (h + x) >> 1;   // Update hidden state (simple update rule)
            y <= h;              // Output current hidden state
        end
    end
endmodule