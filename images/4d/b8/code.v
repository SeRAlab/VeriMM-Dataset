module top_module( input clk, input d, input select, output [2:0] q );reg [2:0] counter;
  reg [2:0] shift_reg;

  always @(posedge clk) begin
    if (select == 1'b0) begin
      shift_reg <= {shift_reg[1:0], d};
    end else begin
      counter <= counter + 1;
    end
  end

  assign q = (select == 1'b0) ? shift_reg : counter;

endmodule