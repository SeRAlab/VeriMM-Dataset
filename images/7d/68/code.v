module top_module(
        ap_start,
        ap_done,
        ap_idle,
        ap_ready,
        jet_tk13DIP_V,
        jet_muPt_V,
        jet_d_V,
        jet_d_V_ap_vld
);input   ap_start;
output   ap_done;
output   ap_idle;
output   ap_ready;
input  [4:0] jet_tk13DIP_V;
input  [7:0] jet_muPt_V;
output  [0:0] jet_d_V;
output   jet_d_V_ap_vld;

reg jet_d_V_ap_vld;

always @ (*) begin
    if ((ap_start == 1'b1)) begin
        jet_d_V_ap_vld = 1'b1;
    end else begin
        jet_d_V_ap_vld = 1'b0;
    end
end

assign ap_done = ap_start;

assign ap_idle = 1'b1;

assign ap_ready = ap_start;

assign jet_d_V = 1'd1;

endmodule