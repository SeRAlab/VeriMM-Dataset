module parity_checker(
  input [3:0] data_in,
  input rst,
  input en,
  input clk,
  output even_parity,
  output odd_parity
);

  reg [1:0] parity;
  reg [3:0] last_data_in;

  always @(posedge clk) begin
    if (rst == 0) begin
      parity <= 2'b0;
      last_data_in <= 4'b0;
    end else if (en == 1) begin
      parity[0] <= data_in[0] ^ data_in[1] ^ data_in[2] ^ data_in[3];
      parity[1] <= ~parity[0];
      last_data_in <= data_in;
    end
  end

  assign even_parity = parity[0];
  assign odd_parity = parity[1];

endmodule