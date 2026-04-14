module top_module(
  input clk, rst,
  output reg green, yellow, red
);// define states
parameter GREEN = 2'b00;
parameter YELLOW = 2'b01;
parameter RED = 2'b10;

// define counters
reg [3:0] green_counter = 4'd0;
reg [3:0] yellow_counter = 4'd0;
reg [3:0] red_counter = 4'd0;

// define state register
reg [1:0] state_reg = GREEN;

always @(posedge clk or posedge rst) begin
  if (rst) begin
    // reset counters and state register
    green_counter <= 4'd0;
    yellow_counter <= 4'd0;
    red_counter <= 4'd0;
    state_reg <= GREEN;
  end else begin
    // increment counters
    green_counter <= green_counter + 1;
    yellow_counter <= yellow_counter + 1;
    red_counter <= red_counter + 1;
    
    // update state based on current state and counter
    case (state_reg)
      GREEN: begin
        if (green_counter == 10) begin
          state_reg <= YELLOW;
          green_counter <= 4'd0;
        end
      end
      YELLOW: begin
        if (yellow_counter == 2) begin
          state_reg <= RED;
          yellow_counter <= 4'd0;
        end
      end
      RED: begin
        if (red_counter == 8) begin
          state_reg <= GREEN;
          red_counter <= 4'd0;
        end
      end
    endcase
  end
end

// generate output signals based on current state
always @* begin
  case (state_reg)
    GREEN: begin
      green <= 1'b1;
      yellow <= 1'b0;
      red <= 1'b0;
    end
    YELLOW: begin
      green <= 1'b0;
      yellow <= 1'b1;
      red <= 1'b0;
    end
    RED: begin
      green <= 1'b0;
      yellow <= 1'b0;
      red <= 1'b1;
    end
  endcase
end

endmodule