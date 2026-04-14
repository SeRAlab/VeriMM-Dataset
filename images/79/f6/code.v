module top_module(
  input lio_buscfg_brstlen2_sr,
  input lio_buscfg_brstlen4_sr,
  input [7:0] m_cdq_haddr_sr,
  output reg [3:0] ibnk_sel_s
);always @* begin
    case ({lio_buscfg_brstlen4_sr,lio_buscfg_brstlen2_sr})
      2'b01: // 2-burst
        begin
          ibnk_sel_s = m_cdq_haddr_sr[1:0];
        end
      2'b10: // 4-burst
        begin
          ibnk_sel_s = m_cdq_haddr_sr[2:1];
        end
      default: // 8-burst
        begin
          ibnk_sel_s = m_cdq_haddr_sr[2:1];
        end
    endcase
  end

endmodule