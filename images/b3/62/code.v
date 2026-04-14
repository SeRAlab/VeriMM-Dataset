module top_module(
    si_rs_awvalid,
    m_payload_i_reg,
    state_reg,
    axaddr_incr,
    next,
    aclk,
    Q,
    S,
    m_axi_awaddr,
    wrap_second_len_r_reg,
    next_pending_r_reg
);input si_rs_awvalid;
input [47:0] m_payload_i_reg;
input [1:0] state_reg;
input [11:0] axaddr_incr;
input next;
input aclk;

output [0:0] Q;
output [3:0] S;
output [11:0] m_axi_awaddr;
output [3:0] wrap_second_len_r_reg;
output next_pending_r_reg;

reg [0:0] Q;
reg [3:0] S;
reg [11:0] m_axi_awaddr;
reg [3:0] wrap_second_len_r_reg;
reg next_pending_r_reg;

reg [47:0] m_payload_i_reg_prev;
reg [1:0] state_reg_prev;
reg next_prev;

always @(posedge aclk) begin
    if (si_rs_awvalid) begin
        S <= m_payload_i_reg[47:44];
    end
    if (next) begin
        next_pending_r_reg <= 1'b1;
    end
    if (axaddr_incr) begin
        m_axi_awaddr <= m_axi_awaddr + axaddr_incr;
    end
    if (m_payload_i_reg[39] != m_payload_i_reg_prev[39]) begin
        Q <= m_payload_i_reg[39:39];
    end
    if (state_reg[1] != state_reg_prev[1]) begin
        wrap_second_len_r_reg <= state_reg[1:0];
    end
    if (next != next_prev) begin
        next_pending_r_reg <= next;
    end
    m_payload_i_reg_prev <= m_payload_i_reg;
    state_reg_prev <= state_reg;
    next_prev <= next;
end

endmodule