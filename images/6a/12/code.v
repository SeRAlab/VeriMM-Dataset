module top_module(
  input        clock,
  input        reset,
  input  [6:0] io_input_0_data,
  input        io_input_0_enable,
  input        io_input_0_reset,
  input  [6:0] io_input_1_data,
  input        io_input_1_enable,
  output [6:0] io_output_data
);reg [6:0] ff;
  reg [31:0] _RAND_0;
  wire [6:0] _T_7;
  wire [6:0] _T_8;
  wire [6:0] _T_9;
  assign _T_7 = io_input_1_enable ? io_input_1_data : _T_8;
  assign _T_8 = io_input_0_reset ? 7'h0 : io_input_0_enable ? io_input_0_data : ff;
  assign _T_9 = io_input_0_reset ? 7'h0 : ff;
`ifdef RANDOMIZE
  integer initvar;
  initial begin
    `ifndef verilator
      #0.002 begin end
    `endif
  `ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{$random}};
  ff = _RAND_0[6:0];
  `endif // RANDOMIZE_REG_INIT
  end
`endif // RANDOMIZE
  always @(posedge clock) begin
    if (reset) begin
      ff <= 7'h0;
    end else begin
      if (io_input_0_reset) begin
        ff <= 7'h0;
      end else begin
        if (io_input_0_enable) begin
          ff <= io_input_0_data;
        end
      end
      if (io_input_1_enable) begin
        ff <= io_input_1_data;
      end
    end
  end
  assign io_output_data = _T_9;
endmodule