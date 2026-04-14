module top_module(
  input clk,
  input reset,
  input coin,
  output reg [11:0] display,
  output reg dispense
);parameter IDLE = 2'b00;
  parameter DISPENSING = 2'b01;
  parameter INVALID_COIN = 2'b10;
  
  reg [1:0] state;
  reg [2:0] delay_count;
  
  always @(posedge clk) begin
    if (reset) begin
      state <= IDLE;
      delay_count <= 0;
      display <= 12'h000; // "INSERT COIN"
      dispense <= 0;
    end
    else begin
      case (state)
        IDLE: begin
          if (coin) begin
            state <= DISPENSING;
            display <= 12'h001; // "THANK YOU"
            dispense <= 1;
          end
          else begin
            state <= IDLE;
            display <= 12'h000; // "INSERT COIN"
            dispense <= 0;
          end
        end
        DISPENSING: begin
          delay_count <= 3;
          state <= DISPENSING;
          display <= 12'h001; // "THANK YOU"
          dispense <= 1;
        end
        INVALID_COIN: begin
          delay_count <= 3;
          state <= IDLE;
          display <= 12'h010; // "INVALID COIN"
          dispense <= 0;
        end
      endcase
    end
  end
  
  always @(posedge clk) begin
    if (delay_count > 0) begin
      delay_count <= delay_count - 1;
    end
    else if (state == DISPENSING) begin
      state <= IDLE;
      display <= 12'h000; // "INSERT COIN"
      dispense <= 0;
    end
  end
  
endmodule