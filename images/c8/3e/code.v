module mux2x1 (
  output reg [3:0] out,
  input sel,
  input [3:0] a,
  input [3:0] b
);
  always @(*) begin
    if(sel == 1'b0) begin
      out = a;
    end else begin
      out = b;
    end
  end
endmodule