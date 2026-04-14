module top_module(
  input clk,
  input reset,
  input load,
  input [7:0] data,
  output reg [7:0] out
);reg [7:0] reg_data;

always @ (posedge clk or negedge reset) begin
  if (reset == 0) begin
    reg_data <= 8'b0;
  end else if (load == 0) begin
    reg_data <= data;
  end else begin
    reg_data <= {reg_data[6:0], reg_data[7]};
  end
end

assign out = reg_data;

endmodule