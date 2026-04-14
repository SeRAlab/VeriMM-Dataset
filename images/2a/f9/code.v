module hmac (
    input [127:0] key,
    input [127:0] message,
    output reg [127:0] hmac_out
);

reg [127:0] ipad = 128'h36363636363636363636363636363636; // Inner padding
reg [127:0] opad = 128'h5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c; // Outer padding

wire [127:0] inner_hash;
wire [127:0] outer_hash;

// Inner hash calculation
assign inner_hash = (key ^ ipad) ^ message; // Simplified hash with XOR

// Outer hash calculation
assign outer_hash = (key ^ opad) ^ inner_hash; // Simplified hash with XOR

always @(*) begin
    hmac_out = outer_hash; // Final HMAC output
end

endmodule