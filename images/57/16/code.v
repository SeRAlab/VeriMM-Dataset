module top_module(
  input [n-1:0] data,
  output [n-1:0] corrected_data
);parameter n = 8; // number of bits in the data
parameter p = 23; // prime number used to define the elliptic curve
parameter a = 1; // coefficient used to define the elliptic curve
parameter b = 1; // coefficient used to define the elliptic curve
parameter Gx = 5; // x coordinate of the base point on the elliptic curve
parameter Gy = 7; // y coordinate of the base point on the elliptic curve
parameter d = 3; // private key used for encryption and decryption

reg [n-1:0] encrypted_data;
reg [n-1:0] parity_bits;
reg [n-1:0] corrected_encrypted_data;
reg [n-1:0] decrypted_data;

// Generate public key using private key
reg [n-1:0] Qx = 0; // Initialize Qx
reg [n-1:0] Qy = 0; // Initialize Qy
reg [n-1:0] k;
reg [n-1:0] kGx;
reg [n-1:0] kGy;

integer i; // Declare i as an integer

always @* begin
  k = d;
  kGx = Gx;
  kGy = Gy;
  for (i = 0; i < n; i = i + 1) begin // Changed to start from 0
    if (k[i] == 1'b1) begin
      Qx = (Qx + kGx) % p;
      Qy = (Qy + kGy) % p;
    end
    kGx = (2 * kGx) % p;
    kGy = (2 * kGy) % p;
  end
end

// Encrypt data using public key
always @* begin
  encrypted_data = (data * Qx) % p;
end

// Add parity bits to encrypted data
always @* begin
  for (i = 0; i < n; i = i + 1) begin
    parity_bits[i] = encrypted_data[i] ^ encrypted_data[(i+1)%n];
  end
  corrected_encrypted_data = encrypted_data ^ parity_bits;
end

// Detect and correct errors in encrypted data using parity bits
always @* begin
  for (i = 0; i < n; i = i + 1) begin
    if (parity_bits[i] == 1'b1) begin
      corrected_encrypted_data[i] = ~corrected_encrypted_data[i];
    end
  end
end

// Decrypt corrected encrypted data using private key
always @* begin
  decrypted_data = (corrected_encrypted_data * d) % p;
end

// Output corrected data
assign corrected_data = decrypted_data;

endmodule