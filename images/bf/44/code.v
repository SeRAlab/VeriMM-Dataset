module top_module(input clk, input d, output q);reg [2:0] register;
  always @(posedge clk) begin
    register <= {register[1:0], d};
  end
  assign q = register[2];
endmodule