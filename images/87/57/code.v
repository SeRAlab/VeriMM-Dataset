module top_module(
        ap_start,
        ap_done,
        ap_idle,
        ap_ready,
        val_V,
        mode,
        ap_return
);input   ap_start;
output   ap_done;
output   ap_idle;
output   ap_ready;
input  [7:0] val_V;
input  [31:0] mode;
output  [7:0] ap_return;

wire   [7:0] xs_V_1_fu_28_p2;
wire   [0:0] p_Result_s_fu_44_p3;
reg   [7:0] p_Result_1_fu_34_p4;

assign ap_done = ap_start;

assign ap_idle = 1'b1;

assign ap_ready = ap_start;

assign ap_return = ((p_Result_s_fu_44_p3[0:0] === 1'b1) ? p_Result_1_fu_34_p4 : val_V);

always @ (*) begin
    p_Result_1_fu_34_p4 = xs_V_1_fu_28_p2;
    p_Result_1_fu_34_p4[32'd7] = |(1'd0);
end

assign p_Result_s_fu_44_p3 = val_V[32'd7];

assign xs_V_1_fu_28_p2 = (8'd0 - val_V);

endmodule