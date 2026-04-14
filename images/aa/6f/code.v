module top_module(request, clk, resetn, stalled);input request;
input clk;
input resetn;
output stalled;

  reg [1:0] state;
  reg [1:0] next_state;

  // State machine for stalling 1 cycle
  always@(state or request) begin
    case(state)
      2'b00: next_state = request ? 2'b01 : 2'b00;
      2'b01: next_state = 2'b10;
      2'b10: next_state = 2'b00;
    endcase
  end

  always@(posedge clk) begin
    if(!resetn) begin
      state <= 2'b00;
    end else begin
      state <= next_state;
    end
  end

  assign stalled = (state == 2'b01) ? 1'b1 : 1'b0;

endmodule