module top_module(
    input [31:0] data,
    input [31:0] key,
    output reg [31:0] encrypted_data
);reg [7:0] D0, D1, D2, D3, K0, K1, K2, K3;
reg [7:0] D0_encrypted, D1_encrypted, D2_encrypted, D3_encrypted;

// Split data into four 8-bit blocks
assign D0 = data[31:24];
assign D1 = data[23:16];
assign D2 = data[15:8];
assign D3 = data[7:0];

// Split key into four 8-bit blocks
assign K0 = key[31:24];
assign K1 = key[23:16];
assign K2 = key[15:8];
assign K3 = key[7:0];

// Encryption algorithm
always @* begin
    D0_encrypted = (D0 ^ K0) << (K0 % 8);
    D1_encrypted = (D1 ^ K1) << (K1 % 8);
    D2_encrypted = (D2 ^ K2) << (K2 % 8);
    D3_encrypted = (D3 ^ K3) << (K3 % 8);

    {D0_encrypted[23:16], D0_encrypted[15:8], D0_encrypted[7:0]} <= {D0_encrypted[15:8], D0_encrypted[7:0], D0_encrypted[23:16]};
    {D1_encrypted[23:16], D1_encrypted[15:8], D1_encrypted[7:0]} <= {D1_encrypted[15:8], D1_encrypted[7:0], D1_encrypted[23:16]};
    {D2_encrypted[23:16], D2_encrypted[15:8], D2_encrypted[7:0]} <= {D2_encrypted[15:8], D2_encrypted[7:0], D2_encrypted[23:16]};
    {D3_encrypted[23:16], D3_encrypted[15:8], D3_encrypted[7:0]} <= {D3_encrypted[15:8], D3_encrypted[7:0], D3_encrypted[23:16]};

    encrypted_data = {D0_encrypted, D1_encrypted, D2_encrypted, D3_encrypted};
end

endmodule