module top_module(
  input               clk,
  input               rst_n,
  input               a,
  input               delay,
  output reg          rise,
  output reg          down
);parameter           PIPELINE_DEPTH = 2;
  reg [PIPELINE_DEPTH-1:0] pipe_a;
  reg [PIPELINE_DEPTH-1:0] pipe_diff;
  reg                 prev_a;
  reg                 prev_diff;

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      pipe_a <= {PIPELINE_DEPTH{1'b0}};
      pipe_diff <= {PIPELINE_DEPTH{1'b0}};
      prev_a <= 1'b0;
      prev_diff <= 1'b0;
      rise <= 1'b0;
      down <= 1'b0;
    end else begin
      pipe_a <= {pipe_a[PIPELINE_DEPTH-2:0], a};
      pipe_diff <= {pipe_diff[PIPELINE_DEPTH-2:0], a ^ prev_a};
      prev_a <= a;
      prev_diff <= pipe_diff[PIPELINE_DEPTH-1];
      rise <= (pipe_diff[PIPELINE_DEPTH-1] == 1'b1) && (pipe_a[PIPELINE_DEPTH-1] == 1'b1) && (pipe_a[PIPELINE_DEPTH-1-delay] == 1'b0);
      down <= (pipe_diff[PIPELINE_DEPTH-1] == 1'b1) && (pipe_a[PIPELINE_DEPTH-1] == 1'b0) && (pipe_a[PIPELINE_DEPTH-1-delay] == 1'b1);
    end
  end

endmodule