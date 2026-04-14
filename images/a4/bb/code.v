module top_module(input [2:0] in_vec, output [2:0] out_vec, output even_parity);reg [2:0] shift_reg;
  wire xor_out;

  assign xor_out = in_vec[0] ^ in_vec[1] ^ in_vec[2];

  always @ (in_vec) begin
    shift_reg <= {in_vec[2], in_vec[1], in_vec[0]};
  end

  assign out_vec = shift_reg;
  assign even_parity = xor_out;

endmodule