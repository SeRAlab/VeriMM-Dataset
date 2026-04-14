module top_module(
  input clk,
  input reset,
  input [1:0] coin,
  input dispense,
  output reg product_dispensed,
  output reg [3:0] excess_money,
  output reg [3:0] display_message,
  output reg [3:0] product_count
);reg [3:0] price = 3; // price of the product in cents
reg [3:0] total_money = 0; // total money inserted
reg [3:0] change = 0; // change to be returned
reg [3:0] stock = 10; // number of products available

always @(posedge clk) begin
  if (reset) begin // reset the vending machine
    product_dispensed <= 0;
    excess_money <= 0;
    display_message <= 0;
    product_count <= 10;
    total_money <= 0;
    change <= 0;
    stock <= 10;
  end else begin
    excess_money <= total_money - price; // calculate excess money
    if (excess_money < 0) begin // not enough money inserted
      product_dispensed <= 0;
      change <= total_money;
      total_money <= 0;
    end else begin // enough money inserted
      product_dispensed <= dispense & (stock > 0);
      if (product_dispensed) begin // dispense product
        stock <= stock - 1;
        change <= excess_money;
        total_money <= 0;
      end else begin // return excess money
        change <= excess_money;
        total_money <= 0;
      end
    end
    if (stock == 0) begin // out of stock
      display_message <= "Sold Out!";
    end else begin // display product count
      display_message <= "Prod: " & product_count;
    end
  end
end

always @(posedge clk) begin
  if (reset) begin // reset the total money inserted
    total_money <= 0;
  end else begin // add money to the total money inserted
    total_money <= total_money + {2'b0, coin};
  end
end

endmodule