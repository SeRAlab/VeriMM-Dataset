module top_module(
  input [7:0] data_in1,
  input [7:0] data_in2,
  input ctrl,
  output reg [7:0] data_out
);always @(*) begin
    if(ctrl) begin
      data_out <= ~(data_in1 + data_in2);
    end else begin
      data_out <= data_in1 + data_in2;
    end
  end

endmodule