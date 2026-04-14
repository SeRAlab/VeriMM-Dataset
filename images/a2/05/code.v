module top_module(
  input ref_clk,
  input fb_clk,
  input reset,
  output out_clk,
  output locked
);parameter n = 10; // number of delay elements in the DLL
parameter m = 4; // multiplication factor of the PLL
parameter p = 2; // division factor of the PLL

reg [n-1:0] delay_line;
reg locked_pll, locked_dll;
reg [31:0] vco_count; // Changed from wire to reg
wire [n-1:0] delayed_clk;
wire [n-1:0] phase_diff;
wire [n-1:0] filtered_diff;
wire [31:0] vco_increment;

// Phase Detector
assign phase_diff = fb_clk ^ delayed_clk;

// Low-Pass Filter
assign filtered_diff = {filtered_diff[n-2:0], phase_diff[0]} + {filtered_diff[n-1], phase_diff[n-1]};

// Voltage-Controlled Oscillator
assign vco_increment = (m * ref_clk) / p;
always @(posedge ref_clk) begin
  if (locked_pll) begin
    vco_count <= vco_count + vco_increment; // vco_count is now a reg
  end
end
assign out_clk = vco_count[31];
assign locked = locked_pll & locked_dll;

// Delay Locked Loop
assign delayed_clk[0] = ref_clk;
genvar i;
generate
  for (i = 1; i < n; i = i + 1) begin : delay_loop
    assign delayed_clk[i] = delay_line[i-1];
  end
endgenerate
assign phase_diff[0] = fb_clk ^ delayed_clk[0];
always @(posedge ref_clk) begin
  if (locked_dll) begin
    if (filtered_diff[n-1]) begin
      delay_line <= {delay_line[n-2:0], 1'b1};
    end else begin
      delay_line <= {delay_line[n-2:0], 1'b0};
    end
  end
end

// Lock Detection
always @(posedge ref_clk or posedge reset) begin
  if (reset) begin
    locked_pll <= 0;
    locked_dll <= 0;
    vco_count <= 0;
  end else begin
    if (phase_diff == 0) begin
      locked_dll <= 1;
    end else begin
      locked_dll <= 0;
    end
    if (vco_count >= (p-1)) begin
      locked_pll <= 1;
    end else begin
      locked_pll <= 0;
    end
  end
end

endmodule