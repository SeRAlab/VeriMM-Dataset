module top_module(
    input [31:0] frontend_i,
    input [31:0] frontend_q,
    input enable,
    output reg [31:0] ddc_in_i,
    output reg [31:0] ddc_in_q,
    output reg [31:0] bb_sample,
    output reg bb_strobe //high on valid sample
);wire [31:0] ddc_out_sample;
    wire ddc_out_strobe;
    wire ddc_out_enable;

    assign ddc_in_i = frontend_i;
    assign ddc_in_q = frontend_q;
    assign bb_sample = ddc_out_sample;
    assign bb_strobe = ddc_out_strobe;
    assign ddc_out_enable = enable;

endmodule