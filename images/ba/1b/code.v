module top_module(
  input signed [width-1:0] data_in,
  input signed [width-1:0] max_val,
  input signed [width-1:0] min_val,
  output reg signed [width-1:0] data_out
);parameter width = 16; // width of the fixed-point number
parameter scale = 8; // number of fractional bits in the fixed-point number

reg [31:0] float_in;
reg [31:0] float_rounded;
reg [31:0] float_max;
reg [31:0] float_min;

always @(*) begin
  float_in = data_in >>> scale; // Arithmetic right shift for scaling
  float_rounded = (float_in[31:0] >= 0) ? (float_in + (1 << (scale - 1))) >>> scale : (float_in - (1 << (scale - 1))) >>> scale; // Manual rounding
  
  // Ensure data_out is in the correct signed range
  float_max = max_val >>> scale;
  float_min = min_val >>> scale;
  
  if ($signed(float_rounded) > float_max) begin
    data_out = max_val; // Use max_val directly
  end else if ($signed(float_rounded) < float_min) begin
    data_out = min_val; // Use min_val directly
  end else begin
    data_out = float_rounded[width-1:0]; // Assign rounded value to output
  end
end

endmodule