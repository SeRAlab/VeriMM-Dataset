module top_module(
  input clk, // clock signal
  input rst, // reset signal
  input data, // data signal
  input en, // enable signal
  input j, // J input for JK latch
  input k, // K input for JK latch
  input t_in, // T input for T latch (renamed to avoid conflict)
  input s, // S input for SR latch
  input r, // R input for SR latch
  output reg d_out, // output of D latch
  output reg jk_out, // output of JK latch
  output reg t_out, // output of T latch
  output reg sr_out // output of SR latch
);parameter n = 4; // number of latches

reg d, jk, t, sr; // flip-flops for storing the latch values

always @(posedge clk) begin
  if (rst == 1) begin
    d <= 0;
    jk <= 0;
    t <= 0;
    sr <= 0;
  end else if (en == 1) begin
    // D latch
    d <= data;
    
    // JK latch
    if (j == 1 && k == 1) begin
      jk <= ~jk;
    end else if (j == 1) begin
      jk <= 1;
    end else if (k == 1) begin
      jk <= 0;
    end
    
    // T latch
    if (t_in == 1) begin
      t <= ~t; // Keep 't' as state variable
    end else if (t_in == 0 && data == 1) begin
      t <= 1;
    end
    
    // SR latch
    if (s == 1 && r == 0) begin
      sr <= 1;
    end else if (s == 0 && r == 1) begin
      sr <= 0;
    end
  end
end

// output the latch values
assign d_out = d;
assign jk_out = jk;
assign t_out = t; // Update output to the state variable
assign sr_out = sr;

endmodule