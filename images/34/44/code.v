module rnn_cell (
    input wire clk,
    input wire reset,
    input wire [7:0] x, // Input data
    output reg [7:0] y, // Output data
    output reg [7:0] h  // Hidden state
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            h <= 8'b0; // Initialize hidden state to zero
            y <= 8'b0; // Initialize output to zero
        end else begin
            h <= (h + x) >> 1; // Update hidden state
            y <= h; // Output the current hidden state
        end
    end
endmodule