module top_module(clock, reset, enable, taken_i, prediction_o);input clock, reset, enable, taken_i;
  output reg prediction_o; // Changed output to reg

  reg [1:0] counter;
  reg [1:0] next_counter;
  reg [1:0] next_state;

  always @(posedge clock) begin
    if (reset) begin
      counter <= 2'b00;
    end else if (enable) begin
      next_counter <= counter;
      if (taken_i) begin
        if (counter < 2) begin
          next_counter <= counter + 2'b01;
        end
      end else begin
        if (counter > 0) begin
          next_counter <= counter - 2'b01;
        end
      end
    end
  end

  always @(*) begin
    case (counter)
      2'b00: begin
        if (next_state == 2'b00) begin
          prediction_o = 1'b0;
        end else begin
          if ($random < 8'h60) begin
            prediction_o = 1'b1;
          end else begin
            prediction_o = 1'b0;
          end
        end
      end
      2'b01: begin
        if (next_state == 2'b00 || next_state == 2'b01) begin
          prediction_o = 1'b0;
        end else begin
          if ($random < 8'h60) begin
            prediction_o = 1'b1;
          end else begin
            prediction_o = 1'b0;
          end
        end
      end
      2'b10: begin
        if (next_state == 2'b11 || next_state == 2'b10) begin
          prediction_o = 1'b1;
        end else begin
          if ($random < 8'h60) begin
            prediction_o = 1'b1;
          end else begin
            prediction_o = 1'b0;
          end
        end
      end
      2'b11: begin
        if (next_state == 2'b11) begin
          prediction_o = 1'b1;
        end else begin
          if ($random < 8'h60) begin
            prediction_o = 1'b1;
          end else begin
            prediction_o = 1'b0;
          end
        end
      end
      default: prediction_o = 1'b0; // Default case to avoid latches
    endcase
  end

  always @(posedge clock) begin
    if (reset) begin
      next_state <= 2'b00;
    end else if (enable) begin
      next_state <= next_counter;
    end
  end

endmodule