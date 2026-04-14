module top_module(
  input clk,
  input reset,
  input [3:0] data,
  input purchase,
  output reg [3:0] display,
  output reg item_dispensed
);// Define state machine states
  parameter IDLE = 2'b00;
  parameter SELECTING = 2'b01;
  parameter DISPENSING = 2'b10;
  
  // Define item prices
  parameter ITEM_1_PRICE = 2;
  parameter ITEM_2_PRICE = 3;
  parameter ITEM_3_PRICE = 4;
  
  // Define state machine registers
  reg [1:0] state;
  reg [3:0] item_selected;
  reg [3:0] item_price;
  reg [3:0] item_dispensed_temp;
  
  // Define state machine outputs
  assign display = (state == IDLE) ? 4'b0001 : (state == SELECTING) ? {4'b0010, item_price} : (state == DISPENSING) ? 4'b0100 : 4'b1111;
  
  // Define state machine logic
  always @(posedge clk) begin
    if (reset) begin
      state <= IDLE;
      item_selected <= 4'b0000;
      item_price <= 4'b0000;
      item_dispensed_temp <= 4'b0000;
      item_dispensed <= 1'b0;
    end else begin
      case (state)
        IDLE: begin
          if (purchase) begin
            state <= SELECTING;
          end
        end
        SELECTING: begin
          item_price <= (data == 4'b0001) ? ITEM_1_PRICE : (data == 4'b0010) ? ITEM_2_PRICE : (data == 4'b0100) ? ITEM_3_PRICE : 4'b0000;
          if (purchase && item_price > 0) begin
            item_selected <= data;
            item_dispensed_temp <= item_selected;
            state <= DISPENSING;
          end
        end
        DISPENSING: begin
          item_dispensed <= 1'b1;
          item_dispensed_temp <= 4'b0000;
          state <= IDLE;
        end
      endcase
    end
  end
  
endmodule