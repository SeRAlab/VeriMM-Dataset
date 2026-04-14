module top_module(
    // Wishbone slave interface
    input         wb_clk_i,
    input         wb_rst_i,
    input         wb_adr_i,
    output [15:0] wb_dat_o,
    input  [15:0] wb_dat_i,
    input  [ 1:0] wb_sel_i,
    input         wb_we_i,
    input         wb_stb_i,
    input         wb_cyc_i,
    output        wb_ack_o,

    // GPIO inputs/outputs
    output reg [13:0] leds_,
    input      [ 7:0] sw_,
    input             pb_,
    input             tick,
    output reg        nmi_pb
  );// Registers and nets
  wire op;
  reg tick_old;
  reg tick1;
  reg nmi_pb_pressed;
  reg [2:0] nmi_cnt;

  // Continuous assignments
  assign op       = wb_cyc_i & wb_stb_i;
  assign wb_ack_o = op;
  assign wb_dat_o = wb_adr_i ? { 2'b00, leds_ }
                             : { 8'h00, sw_ };

  // Behaviour
  always @(posedge wb_clk_i)
    leds_ <= wb_rst_i ? 14'h0
      : ((op & wb_we_i & wb_adr_i) ? wb_dat_i[13:0] : leds_);

  always @(sw_)
    leds_ <= sw_;

  always @(posedge wb_clk_i)
  begin
    tick_old <= tick;
    tick1 <= tick & ~tick_old;
  end

  always @(posedge wb_clk_i)
    nmi_pb_pressed <= !pb_;

  always @(posedge wb_clk_i)
  begin
    if (wb_rst_i)
    begin
      nmi_pb <= 1'b0;
      nmi_cnt <= 3'b111;
    end
    else
    begin
      if (nmi_cnt == 3'b111)
      begin
        if (nmi_pb_pressed != nmi_pb)
        begin
          nmi_pb <= nmi_pb_pressed;
          nmi_cnt <= nmi_cnt + 3'b001; // nmi_cnt <= 3'b000;
        end
      end
      else if (tick1)
        nmi_cnt <= nmi_cnt + 3'b001;
    end
  end

endmodule