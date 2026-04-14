module rnn_cell (
    input wire clk,
    input wire [3:0] x, // input
    output reg [3:0] h // hidden state output
);
    // Weight and bias parameters (define these appropriately)
    reg [3:0] W_h = 4'b0001; // Example weight for h_prev
    reg [3:0] W_x = 4'b0010; // Example weight for x
    reg [3:0] b = 4'b0001;   // Example bias

    reg [3:0] h_prev; // internal hidden state

    always @(posedge clk) begin
        h_prev <= h; // store current hidden state for next cycle
        h <= (h_prev * W_h) + (x * W_x) + b; // update hidden state
    end
endmodule