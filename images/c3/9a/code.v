module parity_check (
  input clk,
  input reset,
  input [7:0] data_in,
  output reg parity_out
);

reg [7:0] pipeline_reg1;
reg [7:0] pipeline_reg2;
reg [7:0] pipeline_reg3;

always @(posedge clk) begin
  if (reset) begin
    pipeline_reg1 <= 8'b0;
    pipeline_reg2 <= 8'b0;
    pipeline_reg3 <= 8'b0;
    parity_out <= 1'b0;
  end else begin
    pipeline_reg1 <= data_in;
    pipeline_reg2 <= pipeline_reg1;
    pipeline_reg3 <= pipeline_reg2;
    parity_out <= ~(pipeline_reg1 ^ pipeline_reg2 ^ pipeline_reg3) & 1'b1;
  end
end

endmodule