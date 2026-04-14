module top_module(
  input clk,
  input reset,
  input [1:0] coin,
  input item,
  output reg [5:0] price,
  output reg dispense,
  output reg [5:0] change,
  output reg [3:0] stock_candy,
  output reg [3:0] stock_chips
);// Constants
  parameter CANDY_PRICE = 50;
  parameter CHIPS_PRICE = 75;
  parameter MAX_STOCK = 10;

  // Registers
  reg [5:0] total_inserted;
  reg [5:0] amount_due;
  reg [5:0] amount_change;
  reg [3:0] stock_candy_reg;
  reg [3:0] stock_chips_reg;

  // Combinational logic
  assign price = item ? CHIPS_PRICE : CANDY_PRICE;
  assign dispense = (amount_due == 0) && (item ? stock_chips_reg : stock_candy_reg) > 0;
  assign change = amount_change;

  // Sequential logic
  always @(posedge clk) begin
    if (reset) begin
      total_inserted <= 0;
      amount_due <= 0;
      amount_change <= 0;
      stock_candy_reg <= MAX_STOCK;
      stock_chips_reg <= MAX_STOCK;
    end else begin
      // Update total inserted
      case (coin)
        2'b01: total_inserted <= total_inserted + 5;
        2'b10: total_inserted <= total_inserted + 10;
        2'b11: total_inserted <= total_inserted + 25;
      endcase

      // Update amount due
      if (item) begin
        amount_due <= CHIPS_PRICE;
      end else begin
        amount_due <= CANDY_PRICE;
      end

      // Dispense item and calculate change
      if (dispense) begin
        if (total_inserted >= amount_due) begin
          amount_change <= total_inserted - amount_due;
          total_inserted <= 0;
          if (item) begin
            stock_chips_reg <= stock_chips_reg - 1;
          end else begin
            stock_candy_reg <= stock_candy_reg - 1;
          end
        end else begin
          amount_change <= 0;
        end
      end
    end
  end

  // Assign outputs
  assign stock_candy = stock_candy_reg;
  assign stock_chips = stock_chips_reg;

endmodule