module top_module(
    input [16:1] inputA,
    input [16:1] inputB,
    input [16:1] c111,
    input [16:1] c112,
    input [16:1] c121,
    input [16:1] c122,
    input [16:1] c211,
    input [16:1] c212,
    input [16:1] c221,
    input [16:1] c222,
    input [16:1] b11,
    input [16:1] b12,
    input [16:1] b21,
    input [16:1] b22,
    output reg [16:1] out1,
    output reg [16:1] out2
);reg [16:1] n1, n2, n3, n4;

function [16:1] sigmoid;
    input [16:1] x;
    begin
        // Simple fixed-point sigmoid approximation
        if (x[16] == 1) begin // if x is negative
            sigmoid = 0; // Approximate to 0
        end else begin
            sigmoid = x / (1 + x); // A simple representation (this is not an accurate sigmoid function)
        end
    end
endfunction

always @(*) begin
    n1 = sigmoid(inputA * c111 + inputB * c121 + b11);
    n2 = sigmoid(inputA * c112 + inputB * c122 + b12);
    n3 = sigmoid(n1 * c211 + n2 * c221 + b21);
    n4 = sigmoid(n1 * c212 + n2 * c222 + b22);
    out1 = n3;
    out2 = n4;
end

endmodule