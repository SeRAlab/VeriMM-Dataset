module top_module(
  output reg [3:0] Q,
  input CLK,
  input RST
);always @(posedge CLK or negedge RST) begin
    if (!RST) begin
      Q <= 4'b0000;
    end
    else begin
      Q <= Q + 1;
    end
  end

endmodule