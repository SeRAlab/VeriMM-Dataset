module top_module(
  input wire clk,
  input wire reset,
  input wire s_arvalid,
  input wire [7:0] s_arlen,
  input wire m_arready,
  input wire next_pending,
  input wire data_ready,
  output wire s_arready,
  output wire m_arvalid,
  output wire next,
  output wire a_push,
  output wire r_push
);localparam SM_IDLE = 2'b00;
localparam SM_CMD_EN = 2'b01;
localparam SM_CMD_ACCEPTED = 2'b10;
localparam SM_DONE = 2'b11;

reg [1:0] state = SM_IDLE;
reg [1:0] state_r1 = SM_IDLE;
reg [1:0] next_state;
reg [7:0] s_arlen_r;

always @(posedge clk) begin
  if (reset) begin
    state <= SM_IDLE;
    state_r1 <= SM_IDLE;
    s_arlen_r <= 0;
  end else begin
    state <= next_state;
    state_r1 <= state;
    s_arlen_r <= s_arlen;
  end
end

always @(*) begin
  next_state = state;
  case (state)
    SM_IDLE:
      if (s_arvalid && data_ready) begin
        next_state = SM_CMD_EN;
      end else begin
        next_state = state;
      end
    SM_CMD_EN:
      if (~data_ready && m_arready && next_pending) begin
        next_state = SM_CMD_ACCEPTED;
      end else if (m_arready && ~next_pending) begin
        next_state = SM_DONE;
      end else if (m_arready && next_pending) begin
        next_state = SM_CMD_EN;
      end else begin
        next_state = state;
      end
    SM_CMD_ACCEPTED:
      if (data_ready) begin
        next_state = SM_CMD_EN;
      end else begin
        next_state = state;
      end
    SM_DONE:
      next_state = SM_IDLE;
    default:
      next_state = SM_IDLE;
  endcase
end

assign m_arvalid = (state == SM_CMD_EN);
assign next = m_arready && (state == SM_CMD_EN);
assign r_push = next;
assign a_push = (state == SM_IDLE);
assign s_arready = ((state == SM_CMD_EN) || (state == SM_DONE)) && (next_state == SM_IDLE);

endmodule