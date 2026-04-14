module top_module(
  input clk,
  input reset,
  input pedestrian_button,
  output reg red_light,
  output reg yellow_light,
  output reg green_light
);reg [3:0] state;

parameter RED = 2'b00;
parameter YELLOW = 2'b01;
parameter GREEN = 2'b10;
parameter YELLOW_PED = 2'b11;

always @(posedge clk) begin
  if (reset) begin
    state <= RED;
    red_light <= 1'b1;
    yellow_light <= 1'b0;
    green_light <= 1'b0;
  end else begin
    case (state)
      RED: begin
        red_light <= 1'b1;
        yellow_light <= 1'b0;
        green_light <= 1'b0;
        if (pedestrian_button) begin
          state <= YELLOW_PED;
        end else begin
          state <= YELLOW;
        end
      end
      YELLOW: begin
        red_light <= 1'b0;
        yellow_light <= 1'b1;
        green_light <= 1'b0;
        state <= GREEN;
      end
      GREEN: begin
        red_light <= 1'b0;
        yellow_light <= 1'b0;
        green_light <= 1'b1;
        if (pedestrian_button) begin
          state <= YELLOW_PED;
        end else begin
          state <= RED;
        end
      end
      YELLOW_PED: begin
        red_light <= 1'b0;
        yellow_light <= 1'b1;
        green_light <= 1'b0;
        state <= RED;
      end
    endcase
  end
end

endmodule