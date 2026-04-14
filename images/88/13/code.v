module top_module(
  input clk,
  input rst_n,
  input en,
  input [31:0] plaintext_addr,
  input [31:0] plaintext_data,
  output [31:0] ciphertext_addr,
  output [31:0] ciphertext_data
);// Define AES module here
  // ...

  reg [31:0] ciphertext_addr_reg;
  reg [31:0] ciphertext_data_reg;
  reg [31:0] plaintext_addr_reg;  // Changed from wire to reg
  reg [31:0] plaintext_data_reg;  // Changed from wire to reg
  wire [31:0] encrypted_addr;      // Declare encrypted_addr as wire
  wire [31:0] encrypted_data;      // Declare encrypted_data as wire

  // Instantiate AES module here
  // ...

  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      ciphertext_addr_reg <= 0;
      ciphertext_data_reg <= 0;
    end else if (en) begin
      plaintext_addr_reg <= plaintext_addr;
      plaintext_data_reg <= plaintext_data;
      // Encrypt plaintext address and data using AES algorithm
      // ...
      ciphertext_addr_reg <= encrypted_addr;
      ciphertext_data_reg <= encrypted_data;
    end
  end

  assign ciphertext_addr = ciphertext_addr_reg;
  assign ciphertext_data = ciphertext_data_reg;

endmodule