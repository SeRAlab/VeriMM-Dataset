module top_module(
  input clk,
  input reset,
  input [127:0] data_in,
  input [127:0] key,
  input mode,
  output reg [127:0] data_out
);reg [127:0] encrypted_data; // Declare the encrypted_data register
  reg [127:0] decrypted_data; // Declare the decrypted_data register

  // Define AES algorithm here
  // ...

  // Mode selection logic
  always @(posedge clk, posedge reset) begin
    if (reset) begin
      // Reset logic here
      data_out <= 128'b0; // Reset data_out to 0 on reset
      encrypted_data <= 128'b0; // Reset encrypted_data to 0
      decrypted_data <= 128'b0; // Reset decrypted_data to 0
    end else begin
      if (mode == 0) begin
        // Encryption logic here
        // Example placeholder for encryption logic
        encrypted_data <= data_in ^ key; // Dummy encryption operation
        data_out <= encrypted_data;
      end else begin
        // Decryption logic here
        // Example placeholder for decryption logic
        decrypted_data <= data_in ^ key; // Dummy decryption operation
        data_out <= decrypted_data;
      end
    end
  end

endmodule