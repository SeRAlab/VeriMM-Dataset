module top_module(
  input  wire [3:0] in_data,
  input  wire       clk,
  input  wire       wrenb,
  input  wire       din,
  output wire [3:0] out_data,
  output wire       hit
);reg [3:0] out_data_reg;
reg       hit_reg;

always @(posedge clk) begin
  if (wrenb) begin
    out_data_reg <= in_data;
    hit_reg <= (in_data >= 0) && (in_data <= 15);
  end
  else begin
    out_data_reg <= din;
    hit_reg <= 0;
  end
end

assign out_data = out_data_reg;
assign hit = hit_reg;

endmodule