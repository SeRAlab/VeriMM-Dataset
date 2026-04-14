module top_module(
  input CLK_IN,
  output reg CLK_OUT
);reg [24:0] counter;

always @(posedge CLK_IN) begin
  counter <= counter + 1;
  if (counter == 25'd4166) begin  // Change to 25 bits to match the counter size
    counter <= 0;
    CLK_OUT <= ~CLK_OUT;
  end
end

endmodule