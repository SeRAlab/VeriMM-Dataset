module rnn_inference (
    input clk,
    input reset,
    input [7:0] x,         // Input vector
    output reg [7:0] y     // Output vector
);
    reg [7:0] state;      // Internal state to hold previous output

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            y <= 8'b0;
            state <= 8'b0;
        end else begin
            state <= y; // Update state with previous output
            y <= state + x; // Output is previous output plus current input
        end
    end
endmodule