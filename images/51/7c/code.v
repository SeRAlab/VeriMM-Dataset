module top_module(
  input CLK,
  input RST,
  output reg [3:0] Q
);always @(posedge CLK) begin
    if(RST) // reset counter
      Q <= 4'b0000;
    else // increment counter
      Q <= Q + 1;
  end

endmodule