module shift_reg (
  input  [3:0] data_i,
  input        we_i,
  input        clk_i,
  input        rst_i,
  output [3:0] data_o,
  output       flag_o
);

reg [3:0] shift_reg;
reg        flag_reg;

always @(posedge clk_i or posedge rst_i) begin
  if (rst_i) begin
    shift_reg <= 4'b0;
    flag_reg  <= 1'b0;
  end
  else begin
    shift_reg <= {shift_reg[2:0], we_i};
    flag_reg  <= (shift_reg == data_i);
  end
end

assign data_o = shift_reg;
assign flag_o = flag_reg;

endmodule