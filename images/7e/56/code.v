module top_module(
  input [n-1:0] in,
  output [m-1:0] out
);parameter n = 4; // number of input signals
parameter m = 2; // number of output signals
parameter I = 1; // value of the constant current
parameter V = 2; // voltage across the load circuit

reg [n-1:0] in_reg;
wire [m-1:0] out_wire;
wire [m-1:0] voltage;
reg [m-1:0] current;

assign out = out_wire;

assign voltage = out * V;

always @(*) begin
  in_reg = in;
  current = I * (in_reg - (n/2));
end

assign out_wire = current > 0 ? current : -current;

endmodule