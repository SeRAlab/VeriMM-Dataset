module top_module(
  output logic [7:0] count,
  input logic clk,
  input logic reset,
  input logic start,
  input logic [7:0] max_value
);logic [7:0] next_count;

  always_ff @(posedge clk) begin
    if (reset) begin
      count <= 0;
      next_count <= 0;
    end else if (start && count < max_value) begin
      count <= count + 1; // Assign directly to count
    end else begin
      count <= 0; // Assign directly to count
    end
  end

endmodule