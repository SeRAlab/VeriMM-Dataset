module top_module(
  input [WIDTH-1:0] DataIn,
  input Write,
  input Set,
  input Reset,
  input Clk,
  output reg [WIDTH-1:0] DataOut
);parameter WIDTH = 8;
parameter RESET_VALUE = 0;

always @(posedge Clk) begin
  if (Reset) begin
    DataOut <= #1 RESET_VALUE;
  end else if (Set) begin
    DataOut <= #1 {WIDTH{1'b1}};
  end else if (Write) begin
    DataOut <= #1 DataIn;
  end
end

endmodule