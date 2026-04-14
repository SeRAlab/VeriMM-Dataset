module top_module(
    input clk,
    input rst,
    input ce,
    input s_axis_data_tvalid,
    output s_axis_data_tready,
    input s_axis_data_tlast,
    input signed [15:0] s_axis_data_tdata_xn_re_0,
    input signed [15:0] s_axis_data_tdata_xn_im_0,
    input s_axis_config_tvalid,
    output s_axis_config_tready,
    input [0:0] s_axis_config_tdata_fwd_inv,
    output m_axis_data_tvalid,
    input m_axis_data_tready,
    output m_axis_data_tlast,
    output signed [24:0] m_axis_data_tdata_xn_re_0,
    output signed [24:0] m_axis_data_tdata_xn_im_0
);reg [31:0] re_in;
reg [31:0] im_in;
reg [31:0] re_out;
reg [31:0] im_out;

assign s_axis_data_tready = 1;
assign s_axis_config_tready = 1;

always @(posedge clk or negedge rst) begin
    if (~rst) begin
        re_in <= 0;
        im_in <= 0;
        re_out <= 0;
        im_out <= 0;
    end else if (ce) begin
        re_in <= s_axis_data_tdata_xn_re_0;
        im_in <= s_axis_data_tdata_xn_im_0;
        
        re_out <= (re_in * 2) + 1;
        im_out <= (im_in * 2) + 1;
        
        re_out <= re_out * 3;
        im_out <= im_out * 3;
    end
end

assign m_axis_data_tvalid = ce;
assign m_axis_data_tlast = s_axis_data_tlast;
assign m_axis_data_tdata_xn_re_0 = re_out[24:0];
assign m_axis_data_tdata_xn_im_0 = im_out[24:0];

endmodule