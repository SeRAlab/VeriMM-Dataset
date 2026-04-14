module top_module(
  input clk,
  input reset,
  input plaintext,
  input key,
  input enable,
  output reg ciphertext
);reg xor1_out;
  reg xor2_out;

  always @(posedge clk) begin
    if (reset) begin
      xor1_out <= 1'b0;
      xor2_out <= 1'b0;
      ciphertext <= 1'b0;
    end else begin
      xor1_out <= plaintext ^ key;
      xor2_out <= plaintext ^ key;
      ciphertext <= enable ? xor1_out : xor2_out;
    end
  end

endmodule