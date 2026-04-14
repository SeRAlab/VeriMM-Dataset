module shift_register (
  input clk,
  input load,
  input [7:0] parallel_in,
  output reg serial_out
);reg [7:0] shift_reg;

always @(posedge clk) begin
    if (load)
        shift_reg <= parallel_in;
    else
        shift_reg <= {shift_reg[6:0], 1'b0};
    
    serial_out <= shift_reg[7];
end

endmodule