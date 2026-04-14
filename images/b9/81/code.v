module top_module(
  input clk,
  input reset,
  output reg green,
  output reg yellow,
  output reg red
);// define the states
  localparam [1:0] GREEN = 2'b00;
  localparam [1:0] YELLOW = 2'b01;
  localparam [1:0] RED = 2'b10;
  
  // define the state register and initialize to GREEN
  reg [1:0] state_reg = GREEN;
  
  // define the counter for each state
  reg [3:0] green_counter = 4'd0;
  reg [3:0] yellow_counter = 4'd0;
  reg [3:0] red_counter = 4'd0;
  
  always @(posedge clk) begin
    if (reset) begin
      state_reg <= GREEN;
      green_counter <= 4'd0;
      yellow_counter <= 4'd0;
      red_counter <= 4'd0;
      green <= 1'b1;
      yellow <= 1'b0;
      red <= 1'b0;
    end
    else begin
      case (state_reg)
        GREEN: begin
          green_counter <= green_counter + 1;
          if (green_counter == 4'd9) begin
            state_reg <= YELLOW;
            green_counter <= 4'd0;
            yellow <= 1'b1;
            green <= 1'b0;
          end
        end
        YELLOW: begin
          yellow_counter <= yellow_counter + 1;
          if (yellow_counter == 4'd1) begin
            state_reg <= RED;
            yellow_counter <= 4'd0;
            red <= 1'b1;
            yellow <= 1'b0;
          end
        end
        RED: begin
          red_counter <= red_counter + 1;
          if (red_counter == 4'd7) begin
            state_reg <= GREEN;
            red_counter <= 4'd0;
            green <= 1'b1;
            red <= 1'b0;
          end
        end
      endcase
    end
  end

endmodule