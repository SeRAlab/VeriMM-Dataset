module top_module(output reg [31:0] Q,
   input wire E,
   input wire [31:0] D,
   input wire CLK,
   input wire CLR);reg [31:0] Q_next;

  always @(posedge CLK) begin
    if (CLR == 1'b1) begin
      Q_next <= 32'b0;
    end else if (E == 1'b1) begin
      Q_next <= D;
    end
  end

  assign Q = Q_next;

endmodule