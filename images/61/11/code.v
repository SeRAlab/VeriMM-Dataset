module top_module(
  input step,
  input dir,
  input clk,
  output reg coil1,
  output reg coil2,
  output reg coil3,
  output reg coil4
);parameter steps_per_rev = 200; // number of steps per revolution

reg [1:0] state = 2'b00; // current state of the stepper motor
reg [7:0] counter = 8'd0; // counter for PWM

always @(posedge clk) begin
  if (step) begin
    if (dir) begin
      // clockwise rotation
      case (state)
        2'b00: begin coil1 <= 1; coil2 <= 0; coil3 <= 0; coil4 <= 0; state <= 2'b01; end
        2'b01: begin coil1 <= 0; coil2 <= 1; coil3 <= 0; coil4 <= 0; state <= 2'b11; end
        2'b11: begin coil1 <= 0; coil2 <= 0; coil3 <= 1; coil4 <= 0; state <= 2'b10; end
        2'b10: begin coil1 <= 0; coil2 <= 0; coil3 <= 0; coil4 <= 1; state <= 2'b00; end
      endcase
    end else begin
      // counter-clockwise rotation
      case (state)
        2'b00: begin coil1 <= 0; coil2 <= 0; coil3 <= 0; coil4 <= 1; state <= 2'b10; end
        2'b10: begin coil1 <= 0; coil2 <= 0; coil3 <= 1; coil4 <= 0; state <= 2'b11; end
        2'b11: begin coil1 <= 0; coil2 <= 1; coil3 <= 0; coil4 <= 0; state <= 2'b01; end
        2'b01: begin coil1 <= 1; coil2 <= 0; coil3 <= 0; coil4 <= 0; state <= 2'b00; end
      endcase
    end
    counter <= counter + 1;
    if (counter >= steps_per_rev) begin
      counter <= 0;
    end
  end else begin
    coil1 <= 0; coil2 <= 0; coil3 <= 0; coil4 <= 0;
  end
end

always @(posedge clk) begin
  if (counter < steps_per_rev/2) begin
    coil1 <= 0;
    coil2 <= 0;
    coil3 <= 0;
    coil4 <= 0;
  end else begin
    case (state)
      2'b00: coil1 <= 1;
      2'b01: coil2 <= 1;
      2'b11: coil3 <= 1;
      2'b10: coil4 <= 1;
    endcase
  end
end

endmodule