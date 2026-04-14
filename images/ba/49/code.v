module top_module(
  input clk,
  input reset,
  input [7:0] data_in,
  input [3:0] control,
  output [7:0] data_out
);reg [7:0] data_out_reg;
  reg [3:0] counter;

  always @(posedge clk) begin
    if (reset) begin
      data_out_reg <= 8'h00;
      counter <= 4'h0;
    end
    else begin
      if (counter == control) begin
        data_out_reg <= {data_in[7], data_in[6], data_in[5], data_in[4], data_in[3], data_in[2], data_in[1], data_in[0]};
        counter <= 4'h0;
      end
      else begin
        data_out_reg <= data_out_reg;
        counter <= counter + 1;
      end
    end
  end

  assign data_out = data_out_reg;

endmodule