module top_module(
  input clk,
  input reset,
  input pedestrian_button,
  output reg traffic_light,
  output reg pedestrian_light
);// define states
  localparam RED = 2'b00;
  localparam GREEN = 2'b01;
  localparam YELLOW = 2'b10;
  
  // define state register and next state logic
  reg [1:0] state, next_state;
  always @ (posedge clk) begin
    if (reset) begin
      state <= RED;
    end else begin
      state <= next_state;
    end
  end
  
  // define output logic
  always @ (*) begin
    case (state)
      RED: begin
        traffic_light = 1'b1;
        pedestrian_light = 1'b0;
      end
      GREEN: begin
        traffic_light = 1'b0;
        pedestrian_light = 1'b1;
      end
      YELLOW: begin
        traffic_light = 1'b0;
        pedestrian_light = 1'b1;
      end
    endcase
  end
  
  // define next state logic
  always @ (*) begin
    case (state)
      RED: begin
        next_state = GREEN;
        if (pedestrian_button) begin
          next_state = YELLOW;
        end
      end
      GREEN: begin
        next_state = YELLOW;
        if (pedestrian_button) begin
          next_state = YELLOW;
        end else if (clk % 30 == 0) begin
          next_state = RED;
        end
      end
      YELLOW: begin
        next_state = RED;
        if (pedestrian_button) begin
          next_state = YELLOW;
        end
      end
    endcase
  end

endmodule