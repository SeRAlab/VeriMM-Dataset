module hmac_simple (
    input [3:0] key,
    input [3:0] message,
    output [3:0] hmac
);
    assign hmac = key ^ message; // HMAC-like operation
endmodule