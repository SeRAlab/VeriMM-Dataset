module top_module(
  input clk,
  input reset,
  input [1:0] state,
  output reg red,
  output reg green,
  output reg yellow
);reg [1:0] current_state;
reg [25:0] counter;

parameter RED_TIME = 25'd500000; // 5 seconds
parameter RED_YELLOW_TIME = 25'd125000; // 1.25 seconds
parameter GREEN_TIME = 25'd750000; // 7.5 seconds
parameter YELLOW_TIME = 25'd125000; // 1.25 seconds

always @(posedge clk) begin
  if (reset) begin
    current_state <= 2'b00; // start with red light
    counter <= RED_TIME;
  end else begin
    case (current_state)
      2'b00: begin // red
        if (counter == 0) begin
          current_state <= 2'b01;
          counter <= RED_YELLOW_TIME;
        end else begin
          counter <= counter - 1;
        end
      end
      2'b01: begin // red-yellow
        if (counter == 0) begin
          current_state <= 2'b10;
          counter <= GREEN_TIME;
        end else begin
          counter <= counter - 1;
        end
      end
      2'b10: begin // green
        if (counter == 0) begin
          current_state <= 2'b11;
          counter <= YELLOW_TIME;
        end else begin
          counter <= counter - 1;
        end
      end
      2'b11: begin // yellow
        if (counter == 0) begin
          current_state <= 2'b00;
          counter <= RED_TIME;
        end else begin
          counter <= counter - 1;
        end
      end
    endcase
  end
end

always @(posedge clk) begin
  case (current_state)
    2'b00: begin // red
      red <= 1;
      green <= 0;
      yellow <= 0;
    end
    2'b01: begin // red-yellow
      red <= 1;
      green <= 0;
      yellow <= 1;
    end
    2'b10: begin // green
      red <= 0;
      green <= 1;
      yellow <= 0;
    end
    2'b11: begin // yellow
      red <= 0;
      green <= 0;
      yellow <= 1;
    end
  endcase
end

endmodule