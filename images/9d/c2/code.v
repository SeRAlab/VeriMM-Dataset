module top_module(
  input [511:0] message,
  output [127:0] hash
);// Constants for MD5
  reg [31:0] A = 32'h67452301;
  reg [31:0] B = 32'hEFCDAB89;
  reg [31:0] C = 32'h98BADCFE;
  reg [31:0] D = 32'h10325476;

  // Padding
  reg [511:0] padded_message;
  always @(*) begin
    padded_message[0] = 1'b1;
    padded_message[511:1] = message;
  end

  // Message Digest Initialization
  reg [127:0] digest;
  always @(*) begin
    digest[31:0] = A;
    digest[63:32] = B;
    digest[95:64] = C;
    digest[127:96] = D;
  end

  // Message Digest Calculation
  integer i;
  reg [31:0] F, G;
  always @(*) begin
    for (i = 0; i < 64; i = i + 1) begin
      if (i < 16) begin
        F = (B & C) | (~B & D);
        G = i;
      end else if (i < 32) begin
        F = (D & B) | (~D & C);
        G = (5 * i + 1) % 16;
      end else if (i < 48) begin
        F = B ^ C ^ D;
        G = (3 * i + 5) % 16;
      end else begin
        F = C ^ (B | ~D);
        G = (7 * i) % 16;
      end

      F = F + A + padded_message[32*G +: 32] + 32'h5A827999;
      A = D;
      D = C;
      C = B;
      B = B + (F << i | F >> (32 - i));
    end
  end

  // Output
  assign hash = digest;

endmodule