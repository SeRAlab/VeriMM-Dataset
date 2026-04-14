module top_module(
  input data_in,
  input clk_ref,
  output reg clk_out // Change to reg, since we are driving it in an always block
);// Phase detector
  reg phase_det;
  always @(posedge clk_ref) begin
    phase_det <= data_in;
  end
  
  // Charge pump
  reg [1:0] charge_pump;
  always @(posedge clk_ref) begin
    if (phase_det == 1'b1) begin
      charge_pump <= 2'b01;
    end else begin
      charge_pump <= 2'b10;
    end
  end
  
  // Loop filter
  reg [7:0] loop_filter;
  always @(posedge clk_ref) begin
    if (charge_pump == 2'b01) begin
      loop_filter <= loop_filter + 8'h01;
    end else if (charge_pump == 2'b10) begin
      loop_filter <= loop_filter - 8'h01;
    end
  end
  
  // Voltage-controlled oscillator (VCO)
  reg [7:0] vco;
  always @(posedge clk_ref) begin
    vco <= vco + loop_filter;
  end
  
  // Jitter filter
  reg [7:0] jitter_filter;
  always @(posedge clk_ref) begin
    jitter_filter <= (jitter_filter + vco) >> 1;
  end
  
  // Output recovered clock
  always @(posedge clk_ref) begin
    clk_out <= jitter_filter[7];
  end

endmodule