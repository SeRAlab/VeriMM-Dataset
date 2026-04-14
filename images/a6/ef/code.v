module top_module(
  input clk,
  input [7:0] pwm_duty_cycle,
  input dir1,
  input dir2,
  input [3:0] step_sequence,
  output reg pwm_out,
  output reg h_bridge_out,
  output reg [3:0] step_out
);parameter clk_freq = 50_000_000; // clock frequency in Hz

// PWM block
reg [31:0] pwm_counter;
always @(posedge clk) begin
  pwm_counter <= pwm_counter + 1;
  if (pwm_counter >= (pwm_duty_cycle * clk_freq / 100)) begin
    pwm_out <= 0;
  end else begin
    pwm_out <= 1;
  end
end

// H-bridge block
always @(dir1 or dir2) begin
  if (dir1 == 1 && dir2 == 0) begin
    h_bridge_out <= 1;
  end else if (dir1 == 0 && dir2 == 1) begin
    h_bridge_out <= 0;
  end else begin
    h_bridge_out <= 0;
  end
end

// Stepper motor controller block
reg [1:0] step_state;
always @(posedge clk) begin
  case (step_state)
    2'b00: begin
      step_out <= step_sequence[0];
      step_state <= 2'b01;
    end
    2'b01: begin
      step_out <= step_sequence[1];
      step_state <= 2'b10;
    end
    2'b10: begin
      step_out <= step_sequence[2];
      step_state <= 2'b11;
    end
    2'b11: begin
      step_out <= step_sequence[3];
      step_state <= 2'b00;
    end
    default: begin
      step_out <= 4'b0000;
      step_state <= 2'b00;
    end
  endcase
end

endmodule