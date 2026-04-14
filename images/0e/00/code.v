module hmac (
    input [3:0] key,
    input [3:0] message,
    output [3:0] hmac_output
);
    assign hmac_output = key ^ message; // Simple XOR for demonstration
endmodule