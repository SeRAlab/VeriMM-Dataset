module top_module(
  input [6:0] A,
  input CE,
  input WEB,
  input OEB,
  input CSB,
  input [127:0] I,
  output reg [127:0] O
);reg [127:0] ram [63:0];

always @(posedge CE) begin
  if (~CSB) begin
    if (~WEB) begin
      ram[A] <= I;
    end
    if (~OEB) begin
      O <= ram[A];
    end
  end
end

endmodule