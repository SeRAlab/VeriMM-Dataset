module top_module(
  input data_in,
  input clk_in,
  output reg data_out,
  output reg clk_out
);// Define parameters and input/output widths as necessary
  parameter SYNC_DELAY = 2; // Number of cycles to delay the synchronized output
  parameter META_THRESHOLD = 3; // Number of cycles to wait for metastability to settle
  
  reg [1:0] sync_state; // State variable for the synchronizer
  reg [1:0] meta_count; // Counter for metastability detection
  
  always @(posedge clk_in) begin
    // First flip-flop
    sync_state[0] <= data_in;
    meta_count[0] <= 0;
  end
  
  always @(posedge clk_in) begin
    // Second flip-flop
    sync_state[1] <= sync_state[0];
    meta_count[1] <= meta_count[0];
  end
  
  always @(posedge clk_in) begin
    // Metastability detection
    if (sync_state[1] != sync_state[0]) begin
      meta_count[0] <= meta_count[1] + 1;
    end else begin
      meta_count[0] <= 0;
    end
  end
  
  always @(posedge clk_in) begin
    // Generate synchronized clock signal
    if (meta_count[1] >= META_THRESHOLD) begin
      clk_out <= ~clk_out;
    end else begin
      clk_out <= clk_in;
    end
  end
  
  always @(posedge clk_in) begin
    // Generate synchronized data signal
    if (meta_count[1] >= META_THRESHOLD + SYNC_DELAY) begin
      data_out <= sync_state[1];
    end
  end

endmodule