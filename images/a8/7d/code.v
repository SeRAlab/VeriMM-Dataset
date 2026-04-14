module top_module(
  input               clk,
  input               rst_n,
  input               a,
  output reg          rise,
  output reg          down
);// Define the states of the state machine
  localparam IDLE = 2'b00;
  localparam RISING = 2'b01;
  localparam FALLING = 2'b10;

  // Define the current state variable
  reg [1:0] state;

  // Define the previous value of the input signal
  reg prev_a;

  // Initialize the state and output signals
  initial begin
    state = IDLE;
    rise = 1'b0;
    down = 1'b0;
  end

  // Detect edges on the rising edge of the clock
  always @(posedge clk) begin
    // Reset the state machine on a low active reset signal
    if (!rst_n) begin
      state <= IDLE;
      rise <= 1'b0;
      down <= 1'b0;
    end
    else begin
      // Check for a rising edge
      if ((a == 1'b1) && (prev_a == 1'b0)) begin
        state <= RISING;
        rise <= 1'b1;
      end
      // Check for a falling edge
      else if ((a == 1'b0) && (prev_a == 1'b1)) begin
        state <= FALLING;
        down <= 1'b1;
      end
      // Stay in the current state otherwise
      else begin
        state <= state;
        rise <= 1'b0;
        down <= 1'b0;
      end
      // Save the current value of the input signal
      prev_a <= a;
    end
  end

endmodule