module top_module(
  input wire clk,
  input wire reset,
  input wire input_bit,
  output reg [1:0] state
);always @(posedge clk or negedge reset) begin
    if (reset == 0) begin
      state <= 2'b00; // reset to state C
    end else begin
      case (state)
        2'b00: begin // state C
          if (input_bit == 0) begin
            state <= 2'b01; // transition to state B
          end else begin
            state <= 2'b00; // stay in state C
          end
        end
        2'b01: begin // state B
          if (input_bit == 0) begin
            state <= 2'b10; // transition to state C
          end else begin
            state <= 2'b01; // stay in state B
          end
        end
        2'b10: begin // state A
          if (input_bit == 0) begin
            state <= 2'b01; // transition to state B
          end else begin
            state <= 2'b10; // stay in state A
          end
        end
      endcase
    end
  end

endmodule