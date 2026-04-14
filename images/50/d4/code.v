module top_module(
  input clk,
  input reset,
  input pedestrian_button,
  input traffic_sensor,
  output reg green_light,
  output reg pedestrian_light
);// Define states
  parameter STATE_RED_ALL = 3'b000;
  parameter STATE_GREEN_PEDESTRIAN = 3'b001;
  parameter STATE_RED_PEDESTRIAN = 3'b010;
  parameter STATE_GREEN_CARS = 3'b011;
  parameter STATE_YELLOW_CARS = 3'b100;

  // Define state register and next state logic
  reg [2:0] state_reg, state_next;
  
  always @ (posedge clk, negedge reset) begin
    if (!reset) begin
      state_reg <= STATE_RED_ALL;
    end else begin
      state_reg <= state_next;
    end
  end
  
  // Define output logic
  always @ (state_reg, pedestrian_button, traffic_sensor) begin
    case (state_reg)
      STATE_RED_ALL: begin
        green_light <= 1'b0;
        pedestrian_light <= 1'b0;
        if (pedestrian_button) begin
          state_next <= STATE_GREEN_PEDESTRIAN;
        end else begin
          state_next <= STATE_RED_ALL;
        end
      end
      STATE_GREEN_PEDESTRIAN: begin
        green_light <= 1'b0;
        pedestrian_light <= 1'b1;
        if (!pedestrian_button) begin
          state_next <= STATE_RED_PEDESTRIAN;
        end else begin
          state_next <= STATE_GREEN_PEDESTRIAN;
        end
      end
      STATE_RED_PEDESTRIAN: begin
        green_light <= 1'b0;
        pedestrian_light <= 1'b0;
        if (traffic_sensor) begin
          state_next <= STATE_GREEN_CARS;
        end else begin
          state_next <= STATE_RED_PEDESTRIAN;
        end
      end
      STATE_GREEN_CARS: begin
        green_light <= 1'b1;
        pedestrian_light <= 1'b0;
        if (!traffic_sensor) begin
          state_next <= STATE_YELLOW_CARS;
        end else begin
          state_next <= STATE_GREEN_CARS;
        end
      end
      STATE_YELLOW_CARS: begin
        green_light <= 1'b0;
        pedestrian_light <= 1'b0;
        state_next <= STATE_RED_ALL;
      end
    endcase
  end

endmodule