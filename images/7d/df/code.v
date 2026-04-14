module decoder1to2 (
  input bin,
  output reg [1:0] onehot
);

  always @(*) begin
    case (bin)
      1'b0: onehot = 2'b01;
      1'b1: onehot = 2'b10;
      default: onehot = 2'b00;
    endcase
  end

endmodule