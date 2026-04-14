module top_module(
  input clk,
  input load,
  input data_in,
  input [7:0] data_parallel,
  output reg [7:0] data_out
);always @(posedge clk) begin
    if (load) begin
      data_out <= data_parallel;
    end else begin
      data_out <= {data_out[6:0], data_in};
    end
  end

endmodule