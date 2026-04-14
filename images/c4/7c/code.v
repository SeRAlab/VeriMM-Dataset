module parity_checker (
  input [7:0] data_in,
  input sel_b1,
  output reg parity
);

  wire xor_out;
  assign xor_out = data_in[0] ^ data_in[1] ^ data_in[2] ^ data_in[3] ^ data_in[4] ^ data_in[5] ^ data_in[6] ^ data_in[7];

  always @(*) begin
    if(sel_b1) begin
      parity <= ~xor_out;
    end else begin
      parity <= xor_out;
    end
  end

endmodule