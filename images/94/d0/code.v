module top_module(
  input clk,
  input reset,
  input go,
  output reg red_led,
  output reg yellow_led,
  output reg green_led
);// FSM states
localparam RED = 2'b00;
localparam RED_YELLOW = 2'b01;
localparam GREEN = 2'b10;
localparam YELLOW = 2'b11;

// FSM state register
reg [1:0] state;

// Counter for state duration
reg [2:0] counter;

// FSM logic
always @(posedge clk) begin
  if (reset) begin
    state <= RED;
    counter <= 3'b000;
  end else if (go) begin
    case (state)
      RED: begin
        if (counter == 3'b100) begin
          state <= RED_YELLOW;
          counter <= 3'b000;
        end else begin
          counter <= counter + 1;
        end
      end
      RED_YELLOW: begin
        if (counter == 3'b10) begin
          state <= GREEN;
          counter <= 3'b000;
        end else begin
          counter <= counter + 1;
        end
      end
      GREEN: begin
        if (counter == 3'b100) begin
          state <= YELLOW;
          counter <= 3'b000;
        end else begin
          counter <= counter + 1;
        end
      end
      YELLOW: begin
        if (counter == 3'b10) begin
          state <= RED;
          counter <= 3'b000;
        end else begin
          counter <= counter + 1;
        end
      end
      default: state <= RED;
    endcase
  end
end

// Output logic
always @(state) begin
  case (state)
    RED: begin
      red_led = 1'b1;
      yellow_led = 1'b0;
      green_led = 1'b0;
    end
    RED_YELLOW: begin
      red_led = 1'b1;
      yellow_led = 1'b1;
      green_led = 1'b0;
    end
    GREEN: begin
      red_led = 1'b0;
      yellow_led = 1'b0;
      green_led = 1'b1;
    end
    YELLOW: begin
      red_led = 1'b0;
      yellow_led = 1'b1;
      green_led = 1'b0;
    end
    default: begin
      red_led = 1'b1;
      yellow_led = 1'b0;
      green_led = 1'b0;
    end
  endcase
end

endmodule