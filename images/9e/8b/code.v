module top_module(
  input [31:0] addr,
  input [31:0] data_in,
  input encrypt,
  output reg [31:0] data_out,  // Change to reg type
  output reg valid              // Change to reg type
);parameter [31:0] SECRET_KEY = 32'h12345678; // Define the secret key

  // Define the encryption and decryption algorithms as Boolean functions
  function [31:0] encrypt_data;
    input [31:0] data;
    begin
      encrypt_data = data ^ SECRET_KEY; // XOR the data with the secret key
    end
  endfunction

  function [31:0] decrypt_data;
    input [31:0] data;
    begin
      decrypt_data = data ^ SECRET_KEY; // XOR the data with the secret key
    end
  endfunction

  always @(*) begin
    if (encrypt) begin // If the encrypt signal is high, encrypt the data_in signal
      data_out = encrypt_data(data_in);
    end
    else begin // If the encrypt signal is low, decrypt the data_in signal
      data_out = decrypt_data(data_in);
    end
    valid = 1; // Set the valid signal high to indicate that the data_out signal contains valid data
  end

endmodule