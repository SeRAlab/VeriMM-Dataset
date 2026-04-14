module rnn_cell (
    input clk,
    input rst,
    input [3:0] x, // Input at each time step
    output reg [3:0] y, // Output after processing input
    input valid // Input valid signal
);
    reg [3:0] h; // Hidden state

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            h <= 4'b0000; // Reset hidden state
            y <= 4'b0000; // Reset output
        end else if (valid) begin
            h <= h + x; // Update hidden state (simple addition for this example)
            y <= h; // Output the current hidden state
        end
    end
endmodule