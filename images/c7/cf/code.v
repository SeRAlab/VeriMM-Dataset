module mux8 (
  input [7:0] d0,
  input [7:0] d1,
  input s,
  output reg [7:0] y
);

  always @(*) begin
    if (s == 1'b0) begin
      y = d0;
    end else begin
      y = d1;
    end
  end

endmodule