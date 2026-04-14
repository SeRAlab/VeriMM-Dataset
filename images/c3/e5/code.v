module watchdog_timer (
  input clk,
  input rst,
  output wdt
);

  parameter timeout = 100; // timeout value in clock cycles
  
  reg [7:0] counter; // 8-bit counter to count clock cycles
  
  always @(posedge clk) begin
    if (rst == 1) begin
      counter <= 0;
      wdt <= 0;
    end
    else begin
      counter <= counter + 1;
      if (counter == timeout) begin
        wdt <= 1;
      end
    end
  end
  
endmodule