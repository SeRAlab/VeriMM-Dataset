module mem_encrypt_decrypt (
  input clk,
  input reset,
  input [7:0] data_in,
  input [7:0] key,
  input enable,
  output [7:0] data_out
);

  reg [7:0] encrypted_data;
  
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      data_out <= 0;
      encrypted_data <= 0;
    end else begin
      if (enable) begin
        encrypted_data <= data_in ^ key;
        data_out <= encrypted_data;
      end else begin
        data_out <= data_in;
      end
    end
  end
  
endmodule