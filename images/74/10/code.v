module top_module(
  input trigger,
  input reset,
  input frequency,
  input duty_cycle,
  output pulse
);// Inputs for monostable pulse generator
// input trigger;
// input reset;

// Inputs for astable pulse generator
// input frequency;
// input duty_cycle;

// Output for both pulse generators
// output pulse;

// Monostable pulse generator
reg monostable_pulse;
always @ (posedge trigger or posedge reset) begin
  if (reset) begin
    monostable_pulse <= 0;
  end else if (trigger) begin
    monostable_pulse <= 1;
    #100; // Pulse duration determined by value of capacitor in circuit
    monostable_pulse <= 0;
  end
end

// Astable pulse generator
reg astable_pulse;
reg [31:0] astable_counter;
reg [31:0] astable_period;
reg [31:0] astable_high_time;
always @ (posedge astable_counter[CLOCK_DIVIDER]) begin
  if (astable_pulse) begin
    if (astable_counter == astable_high_time) begin
      astable_pulse <= 0;
      astable_counter <= 0;
    end else begin
      astable_counter <= astable_counter + 1;
    end
  end else begin
    if (astable_counter == astable_period) begin
      astable_pulse <= 1;
      astable_counter <= 0;
    end else begin
      astable_counter <= astable_counter + 1;
    end
  end
end

// Calculate period and high time based on frequency and duty cycle inputs
localparam CLOCK_DIVIDER = 100000000; // Clock frequency
always @ (frequency, duty_cycle) begin
  astable_period = (CLOCK_DIVIDER / (2 * frequency)) - 1;
  astable_high_time = (astable_period * duty_cycle) / 100;
end

// Connect pulse output to both pulse generators
assign pulse = monostable_pulse | astable_pulse;

endmodule