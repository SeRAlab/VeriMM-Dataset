module top_module(
  input               clk,
  input               reset,
  input               signal,
  input               mode_select,
  output reg          rising_edge,
  output reg          falling_edge,
  output reg [31:0]   duration
);// State machine states
  localparam IDLE = 2'b00;
  localparam RISING_EDGE = 2'b01;
  localparam FALLING_EDGE = 2'b10;
  
  reg [1:0] state = IDLE;
  reg [31:0] start_time = 0;
  
  always @(posedge clk) begin
    if (reset) begin
      state <= IDLE;
      rising_edge <= 1'b0;
      falling_edge <= 1'b0;
      duration <= 32'd0;
    end else begin
      case (state)
        IDLE: begin
          if (mode_select) begin
            state <= RISING_EDGE;
          end
        end
        RISING_EDGE: begin
          if (signal) begin
            rising_edge <= 1'b1;
            start_time <= $realtime;
            state <= FALLING_EDGE;
          end
        end
        FALLING_EDGE: begin
          if (!signal) begin
            falling_edge <= 1'b1;
            duration <= $realtime - start_time;
            state <= IDLE;
          end
        end
      endcase
    end
  end
  
endmodule