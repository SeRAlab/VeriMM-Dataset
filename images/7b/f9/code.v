module debounce(
    input clk,
    input rst,
    input switch_in,

    output switch_out
);

reg [3:0] shift_reg;
reg switch_out;

always @(posedge clk or posedge rst)
begin
  if (rst)
    shift_reg <= 4'b0000;
  else
    shift_reg <= {shift_reg[2:0], switch_in};
end

always @(posedge clk or posedge rst)
begin
  if (rst)
    switch_out <= 0;
  else if (shift_reg == 4'b1111)
    switch_out <= 1;
  else if (shift_reg == 4'b0000)
    switch_out <= 0;
end

endmodule