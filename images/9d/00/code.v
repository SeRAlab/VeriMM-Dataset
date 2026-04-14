module top_module(
  input clk,
  input rst,
  input [15:0] data_in,
  input [7:0] key,
  input encrypt,
  output reg [15:0] data_out // Changed to reg type
);reg [7:0] A;
reg [7:0] B;
reg [7:0] temp;

always @(posedge clk or negedge rst) begin
  if (!rst) begin
    A <= 8'h00;
    B <= 8'h00;
    data_out <= 16'h0000; // Initialize data_out on reset
  end else begin
    if (encrypt) begin // encryption mode
      A <= data_in[15:8];
      B <= data_in[7:0];
      temp <= A;
      A <= (A << 3) ^ B ^ key;
      B <= (B >> 2) ^ temp ^ key;
      temp <= A;
      A <= B;
      B <= temp;
      data_out <= {A, B};
    end else begin // decryption mode
      A <= data_in[7:0];
      B <= data_in[15:8];
      temp <= B;
      B <= (B ^ key) << 2 | (A ^ temp ^ key) >> 6;
      A <= (A ^ key) >> 3 | (B ^ temp ^ key) << 5;
      temp <= A;
      A <= B;
      B <= temp;
      data_out <= {B, A};
    end
  end
end

endmodule