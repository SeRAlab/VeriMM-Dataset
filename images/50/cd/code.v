module top_module(
  input wire [3:0] in_data,
  input wire reset,
  output wire [2:0] out_data
);reg [2:0] out_data_reg;

  always @(*) begin
    if (reset) begin
      out_data_reg <= 3'b0;
    end else begin
      out_data_reg <= in_data + 3'b010;
    end
  end

  assign out_data = out_data_reg;

endmodule