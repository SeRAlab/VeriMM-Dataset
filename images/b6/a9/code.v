module top_module(
    input clk,
    input rst,
    input mem_done_access,
    input v_d_flits_m,
    input [174:0] d_flits_m,
    output reg d_m_cstate,
    output reg [174:0] d_m_areg_flits
);reg [174:0] flits_reg;

always @(posedge clk) begin
    if (rst || mem_done_access) begin
        flits_reg <= 175'h0000;
    end else if (v_d_flits_m && !d_m_cstate) begin
        flits_reg <= d_flits_m;
    end
end

always @(posedge clk) begin
    if (rst || mem_done_access) begin
        d_m_cstate <= 1'b0;
    end else if (!d_m_cstate && v_d_flits_m) begin
        d_m_cstate <= 1'b1;
    end else if (d_m_cstate && flits_reg == 175'h0000) begin
        d_m_cstate <= 1'b0;
    end
end

assign d_m_areg_flits = flits_reg;

endmodule