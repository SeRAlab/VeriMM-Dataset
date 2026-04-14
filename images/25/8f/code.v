module rnn_cell (
    input clk,
    input rst,
    input [3:0] x,
    output reg [3:0] y
);
    reg [3:0] state;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= 4'b0000;
            y <= 4'b0000;
        end else begin
            state <= state + x; // Simple state update
            y <= state; // Output the current state
        end
    end
endmodule