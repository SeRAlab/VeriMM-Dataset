module top_module(
  input [n-1:0] ctrl,
  output [m-1:0] out
);parameter n = 2; // number of control signals
parameter m = 1; // number of output signals
parameter I = 10; // current magnitude in mA
parameter R = 100; // load resistance in ohms

reg [n-1:0] ctrl_reg;
reg [m-1:0] out_reg;
wire i_wire;
wire v_wire;

assign i_wire = I / R;
assign v_wire = i_wire * {ctrl_reg, 1'b1};

assign out = out_reg;

always @ (ctrl) begin
  ctrl_reg <= ctrl;
  out_reg <= v_wire * R;
end

endmodule