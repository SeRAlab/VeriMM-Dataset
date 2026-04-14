module hmac (
    input [4:0] key,
    input [4:0] message,
    output [4:0] digest
);
    assign digest = key ^ message; // HMAC computation using XOR
endmodule