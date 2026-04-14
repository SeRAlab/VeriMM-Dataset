module top_module(
    input clk,
    input rst,
    input dc_done_access,
    input v_m_flits_d,
    input [143:0] m_flits_d,
    output reg [143:0] flits_reg,
    output reg m_d_cstate,
    output [143:0] m_d_areg_flits
);always@(posedge clk) begin
    if(rst || dc_done_access) begin
        flits_reg <= 144'h0000;
        m_d_cstate <= 1'b0;
    end
    else if(v_m_flits_d) begin
        flits_reg <= m_flits_d;
        m_d_cstate <= 1'b1;
    end
end

assign m_d_areg_flits = flits_reg;

endmodule