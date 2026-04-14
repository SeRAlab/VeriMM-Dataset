module hmac(
    input [127:0] key,
    input [127:0] message,
    output [127:0] hmac_out
);
    wire [127:0] temp;
    assign temp = key ^ message; // Simple XOR operation
    assign hmac_out = temp + 128'h1; // Simulated hash operation (Addition)

endmodule