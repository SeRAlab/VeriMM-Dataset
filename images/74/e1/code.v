module top_module( input clk, input d, output reg [2:0] q );reg [2:0] register;

  always @(posedge clk) begin
    register[0] <= d;
    register[1] <= register[0];
    register[2] <= register[1];
  end

  assign q = register;

endmodule