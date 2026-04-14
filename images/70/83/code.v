module clock_divider
(
  input rst_n,
  input clk_50MHz,

  output reg clk_1Hz
);

  reg [25:0] counter; // 26-bit counter to handle division by 50,000,000

  always @(posedge clk_50MHz or negedge rst_n) begin
    if (!rst_n)
	begin
      counter <= 26'd0;
      clk_1Hz <= 1'b0;
    end
	
	else if (counter == 26'd49999999) 
	begin
      counter <= 26'd0;
      clk_1Hz <= ~clk_1Hz; // Toggle output clock
    end
	
	else 
	begin
      counter <= counter + 1;
    end
  end

endmodule