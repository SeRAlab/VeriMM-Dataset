module bidirectional_data_port (
  input clk,
  input reset,
  input [7:0] data_in,
  input direction_control,
  output reg [7:0] data_out
);

  always @(posedge clk, posedge reset) begin
    if (reset) begin
      data_out <= 8'b0;
    end else if (direction_control) begin
      data_out <= data_in;
    end else begin
      data_out <= {data_in[7], data_in[6], data_in[5], data_in[4], data_in[3], data_in[2], data_in[1], data_in[0]};
    end
  end

endmodule
