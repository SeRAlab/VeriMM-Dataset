module top_module(FSM_selector_C,
    FSM_sequential_state_reg_reg,
    clk_IBUF_BUFG,
    AR);output FSM_selector_C;
  output [1:0] FSM_sequential_state_reg_reg;
  input clk_IBUF_BUFG;
  input AR;

  reg FSM_selector_C; // Changed to reg type
  reg [1:0] FSM_sequential_state_reg_reg;

  always @(posedge clk_IBUF_BUFG) begin
    if (FSM_selector_C == 1'b1) begin
      FSM_sequential_state_reg_reg <= 2'b00;
    end else begin
      FSM_sequential_state_reg_reg <= FSM_sequential_state_reg_reg + AR;
    end
  end

  assign FSM_selector_C = (FSM_sequential_state_reg_reg == 2'b11);

endmodule