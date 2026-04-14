module top_module(
      input   io_push_valid,
      output  io_push_ready,
      input   io_push_payload_error,
      input  [31:0] io_push_payload_inst,
      output reg  io_pop_valid,
      input   io_pop_ready,
      output reg  io_pop_payload_error,
      output reg [31:0] io_pop_payload_inst,
      input   io_flush,
      output [0:0] io_occupancy,
      input   io_mainClk,
      input   resetCtrl_systemReset);reg [31:0] fifo[0:127];
  reg [6:0] pushPtr = 0;
  reg [6:0] popPtr = 0;
  reg [6:0] occupancy = 0;
  
  assign io_push_ready = occupancy < 128;
  assign io_occupancy = occupancy;
  
  always @(posedge io_mainClk) begin
    if (resetCtrl_systemReset) begin
      io_pop_valid <= 1'b0;
      io_pop_payload_error <= 1'b0;
      io_pop_payload_inst <= 0;
      pushPtr <= 0;
      popPtr <= 0;
      occupancy <= 0;
    end else begin
      if (io_flush) begin
        io_pop_valid <= 1'b0;
        io_pop_payload_error <= 1'b0;
        io_pop_payload_inst <= 0;
        pushPtr <= 0;
        popPtr <= 0;
        occupancy <= 0;
      end else begin
        if (io_push_valid && io_push_ready) begin
          fifo[pushPtr] <= {io_push_payload_error, io_push_payload_inst};
          pushPtr <= pushPtr + 1;
          occupancy <= occupancy + 1;
        end
        if (io_pop_ready && occupancy > 0) begin
          io_pop_valid <= 1'b1;
          io_pop_payload_error <= fifo[popPtr][31];
          io_pop_payload_inst <= fifo[popPtr][30:0];
          popPtr <= popPtr + 1;
          occupancy <= occupancy - 1;
        end else begin
          io_pop_valid <= 1'b0;
          io_pop_payload_error <= 1'b0;
          io_pop_payload_inst <= 0;
        end
      end
    end
  end

endmodule