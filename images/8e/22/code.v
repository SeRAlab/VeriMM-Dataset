module top_module(
  input clk,
  input reset,
  input [7:0] in_data,
  output out_data
);reg [7:0] data_reg;
  reg [3:0] bit_counter;
  reg out_data_reg;

  always @(posedge clk, negedge reset) begin
    if(!reset) begin
      data_reg <= 0;
      bit_counter <= 0;
      out_data_reg <= 0;
    end else begin
      data_reg <= in_data;
      bit_counter <= 0;
      out_data_reg <= 0;
    end
  end

  always @(posedge clk) begin
    if(bit_counter < 8) begin
      out_data_reg <= data_reg[bit_counter];
      bit_counter <= bit_counter + 1;
    end else begin
      bit_counter <= 0;
    end
  end

  assign out_data = out_data_reg;

endmodule