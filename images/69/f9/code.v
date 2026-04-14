module top_module(
  input clk,
  input rst,
  output reg en, // Changed to reg type
  output to
);parameter t = 100; // timeout period in clock cycles
  
  reg [7:0] counter;
  reg timeout;
  
  always @(posedge clk) begin
    if (rst) begin
      counter <= 0;
      timeout <= 0;
      en <= 1; // This is now valid since en is declared as reg
    end
    else begin
      counter <= counter + 1;
      if (counter == t) begin
        timeout <= 1;
        en <= 0; // This is now valid since en is declared as reg
      end
    end
  end
  
  always @(posedge clk) begin
    if (rst) begin
      timeout <= 0;
    end
    else begin
      if (counter == t) begin
        timeout <= 1;
      end
      else begin
        timeout <= 0;
      end
    end
  end
  
  assign to = timeout;
  
endmodule