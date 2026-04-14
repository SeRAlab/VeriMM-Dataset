module top_module(
  input clk,
  input reset,
  input [7:0] data,
  output reg pulse
);parameter S0 = 2'b00; // Idle state
  parameter S1 = 2'b01; // First bit of pattern detected
  parameter S2 = 2'b10; // Second bit of pattern detected
  parameter S3 = 2'b11; // Pattern detected
  
  reg [1:0] state; // FSM state register
  reg [7:0] shift_reg; // Shift register for input data
  
  always @(posedge clk) begin
    if (reset) begin
      state <= S0;
      shift_reg <= 8'h00;
      pulse <= 1'b0;
    end
    else begin
      case (state)
        S0: begin // Idle state
          shift_reg <= {shift_reg[6:0], data}; // Shift in new data
          if (shift_reg == 8'b10110101) begin // Detect pattern
            state <= S3;
            pulse <= 1'b1; // Output pulse
          end
          else if (shift_reg[7] == 1'b1) begin // First bit detected
            state <= S1;
          end
        end
        S1: begin // First bit detected
          shift_reg <= {shift_reg[6:0], data}; // Shift in new data
          if (shift_reg[7:6] == 2'b10) begin // Second bit detected
            state <= S2;
          end
          else if (shift_reg[7] == 1'b0) begin // Reset if pattern not found
            state <= S0;
          end
        end
        S2: begin // Second bit detected
          shift_reg <= {shift_reg[6:0], data}; // Shift in new data
          if (shift_reg[7:5] == 3'b101) begin // Pattern detected
            state <= S3;
            pulse <= 1'b1; // Output pulse
          end
          else if (shift_reg[7:6] != 2'b10) begin // Reset if pattern not found
            state <= S0;
          end
        end
        S3: begin // Pattern detected
          shift_reg <= {shift_reg[6:0], data}; // Shift in new data
          if (shift_reg[7:0] != 8'b10110101) begin // Reset if pattern not found
            state <= S0;
          end
        end
      endcase
    end
  end

endmodule