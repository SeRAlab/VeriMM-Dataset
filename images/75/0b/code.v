module top_module(
  input ref_clk,
  input fb_clk,
  output reg out_clk // changed to reg since we need to assign values in always block
);parameter N = 10; // integer multiplication factor
parameter M = 5; // integer division factor
parameter C = 100; // number of cycles required for the PLL to lock

reg [31:0] counter = 0;
reg locked = 0;
reg [31:0] phase_accumulator = 0;
reg [31:0] phase_difference = 0;

wire multiplied_clk;
wire divided_clk;

// Multiply the reference clock signal by the integer factor N
assign multiplied_clk = ref_clk * N;

// Divide the multiplied clock signal by the integer factor M
assign divided_clk = multiplied_clk / M;

// Phase detector to compare the divided clock signal to the feedback clock signal
always @(posedge divided_clk or posedge fb_clk) begin
  if (fb_clk) begin
    phase_accumulator <= phase_accumulator + phase_difference;
    phase_difference <= 0;
  end else begin
    phase_difference <= phase_difference + 1;
  end
end

// Feedback loop to adjust the output clock signal until it is locked to the reference clock signal
always @(posedge divided_clk) begin
  if (counter < C) begin
    counter <= counter + 1;
  end else if (!locked) begin
    if (phase_accumulator >= 0) begin
      out_clk <= 1;
    end else begin
      out_clk <= 0;
    end
    phase_accumulator <= phase_accumulator - 2**31;
    locked <= 1;
  end else begin
    if (phase_accumulator >= 0) begin
      out_clk <= 1;
    end else begin
      out_clk <= 0;
    end
    phase_accumulator <= phase_accumulator - 2**31 + phase_difference;
  end
end

endmodule