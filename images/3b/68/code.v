module rnn_inference(
    input wire clk,
    input wire reset,
    input wire [3:0] x,       // Input vector
    input wire [3:0] w_hx,    // Weights for input
    input wire [3:0] w_hh,    // Weights for hidden state
    output reg [3:0] h        // Updated hidden state
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            h <= 4'b0000; // Reset hidden state
        end else begin
            h <= (w_hx & x) + (w_hh & h); // Update hidden state
        end
    end
endmodule