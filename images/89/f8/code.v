module top_module(
  output reg clk
);reg [31:0] counter;

  always @ (posedge clk)
    counter <= counter + 1;

  always @ (counter)
    begin
      if (counter >= 125)
        clk <= 1;
      else
        clk <= 0;
    end

endmodule