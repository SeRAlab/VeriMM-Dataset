module top_module(
  input [15:0] data_in,
  input enable,
  output reg [15:0] data_out,
  output reg valid
);always @ (posedge enable) begin
    if (enable) begin
      data_out[15:12] = ~data_in[15:12];
      data_out[11:0] = data_in[11:0];
      valid = 1;
    end
  end

  always @ (negedge enable) begin
    valid = 0;
  end

endmodule