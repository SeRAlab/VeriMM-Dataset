module top_module(
  input clk,
  input reset,
  input data,
  output reg detected
);// Define states
  localparam IDLE = 2'b00;
  localparam STATE1 = 2'b01;
  localparam STATE2 = 2'b10;

  // Define pattern to detect
  localparam PATTERN = 3'b101;

  // Define current state
  reg [1:0] state;

  // Define shift register
  reg [2:0] shift_reg;

  // Define output register
  reg output_reg;

  // Define clocked process
  always @(posedge clk) begin
    if (reset) begin
      // Reset state and shift register
      state <= IDLE;
      shift_reg <= 3'b0;
      output_reg <= 1'b0;
    end else begin
      // Shift in new data
      shift_reg <= {shift_reg[1:0], data};

      // State machine
      case(state)
        IDLE: begin
          if (shift_reg == PATTERN) begin
            state <= STATE1;
            output_reg <= 1'b1;
          end else begin
            state <= IDLE;
            output_reg <= 1'b0;
          end
        end
        STATE1: begin
          state <= STATE2;
          output_reg <= 1'b1;
        end
        STATE2: begin
          state <= IDLE;
          output_reg <= 1'b0;
        end
      endcase
    end
  end

  // Assign output
  assign detected = output_reg;

endmodule