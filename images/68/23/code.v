module top_module(
  input clk,
  input reset,
  input [7:0] parallel_in,
  input enable,
  output reg [7:0] serial_out
);reg [7:0] shift_reg;

  always @(posedge clk, posedge reset) begin
    if (reset) begin
      shift_reg <= 8'b0;
    end else begin
      if (enable) begin
        serial_out <= shift_reg;
      end else begin
        serial_out <= 8'b0;
      end
      
      shift_reg <= {parallel_in, shift_reg[7:1]};
    end
  end
  
endmodule