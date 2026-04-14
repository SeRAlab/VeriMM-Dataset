module top_module(
  input [3:0] data_in,
  input load,
  input shift,
  input reset,
  output reg [3:0] data_out
);always @ (posedge shift or posedge load or posedge reset) begin
    if (reset) begin
      data_out <= 4'b0000;
    end else if (load) begin
      data_out <= data_in;
    end else begin
      data_out <= {data_out[2:0], 1'b0};
    end
  end

endmodule