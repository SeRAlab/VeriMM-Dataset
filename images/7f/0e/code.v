module top_module(
  input clk,
  input reset,
  input data_in,
  input valid_in,
  output reg data_out,
  output reg valid_out
);parameter k = 3; // constraint length of the convolutional code
parameter n = 2; // code rate of the convolutional code
parameter m = 8; // number of states in the Viterbi decoder

// Trellis diagram
reg [k-1:0] trellis [0:m-1];

// Branch metrics
reg [n-1:0] branch_metric [0:m-1];

// Path metrics
reg [31:0] path_metric [0:m-1];

// Most likely path
reg [k-2:0] most_likely_path [0:m-1];

integer i, j;

always @(posedge clk or posedge reset) begin
  if (reset) begin
    valid_out <= 0;
    data_out <= 0;
  end else begin
    // Compute branch metrics
    for (i = 0; i < m; i = i + 1) begin
      branch_metric[i] <= data_in ^ trellis[i];
    end

    // Update path metrics
    for (i = 0; i < m; i = i + 1) begin
      path_metric[i] <= path_metric[i] + branch_metric[i];
    end

    // Determine most likely path
    for (i = 0; i < m; i = i + 1) begin
      most_likely_path[i] <= most_likely_path[i] & (path_metric[i] < path_metric[i+1]);
    end

    // Decode input data
    if (valid_in) begin
      data_out <= most_likely_path[0];
      valid_out <= 1;
    end else begin
      valid_out <= 0;
    end
  end
end

endmodule