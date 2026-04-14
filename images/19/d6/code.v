module rnn_cell (
    input clk,
    input rst,
    input [4:0] x,    // 5-bit input
    output reg [4:0] y // 5-bit output
);

reg [4:0] h; // hidden state
wire [4:0] w; // weights
wire [4:0] b; // biases

// hardcoded weights and biases
assign w = 5'b10101; // example weights
assign b = 5'b00011; // example biases

// simple activation function (sigmoid-like)
function [4:0] sigmoid;
    input [4:0] in;
    begin
        sigmoid = (in > 5'b00111) ? 5'b11111 : 5'b00000; // threshold-based activation
    end
endfunction

always @(posedge clk or posedge rst) begin
    if (rst) begin
        h <= 5'b00000;
        y <= 5'b00000;
    end else begin
        h <= sigmoid((x * w) + b); // compute hidden state
        y <= h; // output the hidden state
    end
end

endmodule