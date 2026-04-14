module rnn_inference (
    input clk,
    input rst,
    input [4:0] x,  // input data
    output reg [4:0] h  // hidden state output
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            h <= 5'b00000;  // reset hidden state
        end else begin
            h <= h ^ x;  // update hidden state
        end
    end
endmodule