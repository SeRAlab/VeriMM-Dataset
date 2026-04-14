module top_module(CLOCK_50, COIN, BUTTON, RESET, CANDY_DISPENSE, CHANGE_DISPENSE);input CLOCK_50;
  input [1:0] COIN;
  input BUTTON, RESET;
  output CANDY_DISPENSE;
  output [1:0] CHANGE_DISPENSE;

  reg [7:0] candy_count;
  reg [7:0] change_count;
  reg [1:0] inserted_value;
  reg candy_dispensed;
  reg [1:0] change_dispensed;

  parameter CANDY_PRICE = 35;
  parameter COIN_5 = 5;
  parameter COIN_10 = 10;
  parameter COIN_25 = 25;

  always @(posedge CLOCK_50) begin
    if (RESET) begin
      candy_count <= 0;
      change_count <= 0;
      inserted_value <= 0;
      candy_dispensed <= 0;
      change_dispensed <= 0;
    end else begin
      case (COIN)
        2'b00: inserted_value <= inserted_value + COIN_5;
        2'b01: inserted_value <= inserted_value + COIN_10;
        2'b10: inserted_value <= inserted_value + COIN_25;
        2'b11: inserted_value <= inserted_value;
      endcase

      if (BUTTON && inserted_value >= CANDY_PRICE && candy_count > 0) begin
        candy_dispensed <= 1;
        candy_count <= candy_count - 1;
        change_dispensed <= inserted_value - CANDY_PRICE;
        inserted_value <= 0;
      end else begin
        candy_dispensed <= 0;
        change_dispensed <= 0;
      end
    end
  end

  always @(posedge CLOCK_50) begin
    if (RESET) begin
      candy_count <= 10;
      change_count <= 100;
    end else begin
      case (COIN)
        2'b00: change_count <= change_count + COIN_5;
        2'b01: change_count <= change_count + COIN_10;
        2'b10: change_count <= change_count + COIN_25;
        2'b11: change_count <= change_count;
      endcase
    end
  end

  assign CANDY_DISPENSE = candy_dispensed;
  assign CHANGE_DISPENSE = change_dispensed;
endmodule