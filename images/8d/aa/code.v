module top_module(
  input clk,
  input reset,
  input data,
  output reg match
);// Define the two states
  localparam IDLE = 2'b00;
  localparam DETECTED = 2'b01;

  // Define the state register and initialize to IDLE
  reg [1:0] state = IDLE;

  // Define the sequence detection logic
  always @(posedge clk, negedge reset) begin
    if (reset == 1'b0) begin
      state <= IDLE;
      match <= 1'b0;
    end else begin
      case(state)
        IDLE: begin
          if (data == 1'b1) begin
            state <= DETECTED;
          end else begin
            state <= IDLE;
          end
        end
        DETECTED: begin
          if (data == 1'b0) begin
            state <= IDLE;
            match <= 1'b0;
          end else begin
            state <= DETECTED;
            match <= 1'b1;
          end
        end
      endcase
    end
  end

endmodule