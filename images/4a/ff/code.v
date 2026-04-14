module mux2to1_8bit(
    input [7:0] a,
    input [7:0] b,
    input sel,

    output reg [7:0] y
);

always @(*)
begin
  if (sel)
    y = b;
  else
    y = a;
end

endmodule