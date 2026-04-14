module shift_left_2 (
  input [33:0] in_signal,
  output reg [35:0] out_signal
);

  always @(*) begin
    out_signal = {in_signal, 2'b00};
  end

endmodule