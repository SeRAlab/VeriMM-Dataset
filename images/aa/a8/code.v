module top_module(
  input [63:0] msg,
  output [127:0] hash
);// Constants for MD5 initialization
  reg [31:0] A = 32'h67452301;
  reg [31:0] B = 32'hEFCDAB89;
  reg [31:0] C = 32'h98BADCFE;
  reg [31:0] D = 32'h10325476;

  // Padding the input message
  reg [511:0] padded_msg;
  always @(*) begin
    padded_msg[63:0] = msg;
    padded_msg[64] = 1'b1;
    padded_msg[511:65] = 0;
  end

  // Dividing the padded message into 16 32-bit blocks
  reg [31:0] M[15:0];
  integer i;
  always @(*) begin
    for (i = 0; i < 16; i = i + 1) begin
      M[i] = padded_msg[i*32 +: 32];
    end
  end

  // MD5 processing
  reg [31:0] AA, BB, CC, DD;
  reg [31:0] F, G;
  integer j;
  always @(*) begin
    AA = A;
    BB = B;
    CC = C;
    DD = D;

    for (j = 0; j < 64; j = j + 1) begin
      if (j < 16) begin
        F = (BB & CC) | (~BB & DD);
        G = j;
      end else if (j < 32) begin
        F = (DD & BB) | (~DD & CC);
        G = (5*j + 1) % 16;
      end else if (j < 48) begin
        F = BB ^ CC ^ DD;
        G = (3*j + 5) % 16;
      end else begin
        F = CC ^ (BB | ~DD);
        G = (7*j) % 16;
      end

      F = F + AA + M[G] + (j < 16 ? 32'hd76aa478 : j < 32 ? 32'he8c7b756 : j < 48 ? 32'h242070db : 32'hC1BDCEEE);
      AA = DD;
      DD = CC;
      CC = BB;
      BB = BB + (F << (j % 4 * 7 + 7)) | (F >> (32 - (j % 4 * 7 + 7)));
    end

    A = A + AA;
    B = B + BB;
    C = C + CC;
    D = D + DD;
  end

  // Output the final hash value
  assign hash = {A, B, C, D};

endmodule