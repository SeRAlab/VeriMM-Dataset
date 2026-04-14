module synchronizer_ff(
  input [3:0] D,
  input CLK,
  input AR,
  output reg [3:0] Q
);

  always @(posedge CLK) begin
    if (AR) begin
      Q <= 4'b0000;
    end else begin
      Q <= D;
    end
  end

endmodule