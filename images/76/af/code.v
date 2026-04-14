module top_module(
  input         clock,
  input         reset,
  input  [31:0] io_input_0_data,
  input  [31:0] io_input_0_init,
  input         io_input_0_enable,
  input         io_input_0_reset,
  output [31:0] io_output_data
);reg [31:0] ff;
  reg [31:0] _RAND_0;
  wire [31:0] _T_7;
  wire [31:0] _T_8;
  wire [31:0] _T_9;
  assign _T_7 = io_input_0_enable ? io_input_0_data : ff;
  assign _T_8 = io_input_0_reset ? io_input_0_init : _T_7;
  assign _T_9 = io_input_0_reset ? io_input_0_init : ff;
  assign io_output_data = _T_9;
`ifdef RANDOMIZE
  integer initvar;
  initial begin
    `ifndef verilator
      #0.002 begin end
    `endif
  `ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{$random}};
  ff = _RAND_0[31:0];
  `endif // RANDOMIZE_REG_INIT
  end
`endif // RANDOMIZE
  always @(posedge clock) begin
    if (reset) begin
      ff <= io_input_0_init;
    end else begin
      if (io_input_0_reset) begin
        ff <= io_input_0_init;
      end else begin
        if (io_input_0_enable) begin
          ff <= io_input_0_data;
        end
      end
    end
  end
endmodule