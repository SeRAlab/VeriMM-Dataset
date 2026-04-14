module top_module(
  input clk,
  input rst,
  input [31:0] timeout,
  output wdt
);reg [31:0] counter;
  reg wdt_reg;

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      counter <= 0;
      wdt_reg <= 0;
    end else begin
      counter <= counter + 1;
      if (counter == timeout) begin
        wdt_reg <= 1;
      end else begin
        wdt_reg <= 0;
      end
    end
  end

  assign wdt = wdt_reg;

endmodule