module parallel_to_serial (
  input clk,
  input rst,
  input load,
  input [9:0] data,
  output reg serial_out);

reg [9:0] shift_reg;

always @(posedge clk) begin
    if (rst)
        shift_reg <= 10'b0000000000;
    else if (load)
        shift_reg <= data;
    else
        shift_reg <= {1'b0, shift_reg[9:1]};
        
    serial_out <= shift_reg[0];
end
endmodule