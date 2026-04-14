module simple_rnn (
    input wire clk,
    input wire reset,
    input wire [7:0] x, // input
    output reg [7:0] h   // hidden state (output)
);
    reg [7:0] h_prev; // previous hidden state

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            h <= 8'b0;      // initialize hidden state to 0
            h_prev <= 8'b0; // initialize previous hidden state to 0
        end else begin
            h <= (h_prev + x > 8'b11111111) ? 8'b11111111 : (h_prev + x); // ReLU activation
            h_prev <= h; // update previous hidden state
        end
    end
endmodule