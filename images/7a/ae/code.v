module top_module(input [7:0] din, input gate, output reg [7:0] dout);reg [7:0] state;

  always @(gate or din)
  begin
    if (gate == 1'b1)
    begin
      dout <= din;
    end
  end

endmodule