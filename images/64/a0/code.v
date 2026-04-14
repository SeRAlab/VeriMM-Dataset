module top_module(
  input clk, // system clock
  input btn_a, // button A
  input btn_b, // button B
  input btn_c, // button C
  input coin_slot, // 25-cent coin slot
  output reg item_x, // dispensed item X
  output reg item_y, // dispensed item Y
  output reg item_z, // dispensed item Z
  output reg out_of_stock // machine is out of stock
);reg [1:0] state; // state machine state
  reg [3:0] stock_x = 4; // initial stock of item X
  reg [2:0] stock_y = 3; // initial stock of item Y
  reg [2:0] stock_z = 3; // initial stock of item Z
  reg [7:0] total_money = 0; // total money inserted
  
  parameter IDLE = 2'b00; // state machine states
  parameter BUTTON_PRESSED = 2'b01;
  parameter ITEM_DISPENSED = 2'b10;
  
  always @(posedge clk) begin
    case(state)
      IDLE: begin
        if(btn_a || btn_b || btn_c) begin
          state <= BUTTON_PRESSED;
        end
      end
      BUTTON_PRESSED: begin
        if(coin_slot) begin
          total_money <= total_money + 25;
          state <= ITEM_DISPENSED;
        end else if(!btn_a && !btn_b && !btn_c) begin
          state <= IDLE;
        end
      end
      ITEM_DISPENSED: begin
        if(total_money >= 75) begin
          if(btn_a && stock_x > 0) begin
            item_x <= 1;
            stock_x <= stock_x - 1;
            total_money <= total_money - 75;
          end else if(btn_b && stock_y > 0) begin
            item_y <= 1;
            stock_y <= stock_y - 1;
            total_money <= total_money - 75;
          end else if(btn_c && stock_z > 0) begin
            item_z <= 1;
            stock_z <= stock_z - 1;
            total_money <= total_money - 75;
          end
          state <= IDLE;
        end else if(!coin_slot) begin
          state <= BUTTON_PRESSED;
        end
      end
    endcase
  end
  
  always @(stock_x, stock_y, stock_z) begin
    if(stock_x == 0 && stock_y == 0 && stock_z == 0) begin
      out_of_stock <= 1;
    end else begin
      out_of_stock <= 0;
    end
  end
  
endmodule