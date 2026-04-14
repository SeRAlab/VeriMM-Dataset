module top_module(
  input clk,
  input reset,
  input quarter,
  output reg item_dispensed
);reg [1:0] state;
  reg [1:0] quarters;

  always @(posedge clk, posedge reset) begin
    if (reset) begin
      state <= 2'b00;
      quarters <= 2'b00;
      item_dispensed <= 1'b0;
    end else begin
      case(state)
        2'b00: begin // idle
          quarters <= 2'b00;
          item_dispensed <= 1'b0;
          if (quarter) begin
            quarters <= quarters + 1;
            state <= 2'b01; // transition to accepting state
          end
        end
        2'b01: begin // accepting
          if (quarter) begin
            quarters <= quarters + 1;
            if (quarters == 2'b11) begin
              state <= 2'b10; // transition to dispensing state
              item_dispensed <= 1'b1;
            end
          end else begin
            state <= 2'b00; // transition back to idle state
          end
        end
        2'b10: begin // dispensing
          item_dispensed <= 1'b1;
          state <= 2'b00; // transition back to idle state
        end
      endcase
    end
  end

endmodule