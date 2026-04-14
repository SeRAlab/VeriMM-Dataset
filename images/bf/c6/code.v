module Switch_Filter(
    input  clock,
    input  reset,
    input  [7:0] switch_in,
    output reg [7:0] switch_out
    );
    reg [5:0] c7, c6, c5, c4, c3, c2, c1, c0;
    always @(posedge clock) begin
        c0 <= (reset) ? 6'h20 : ((switch_in[0] & (c0 != 6'h3F)) ? c0 + 1 : ((~switch_in[0] & (c0 != 6'h00)) ? c0 - 1 : c0));
        c1 <= (reset) ? 6'h20 : ((switch_in[1] & (c1 != 6'h3F)) ? c1 + 1 : ((~switch_in[1] & (c1 != 6'h00)) ? c1 - 1 : c1));
        c2 <= (reset) ? 6'h20 : ((switch_in[2] & (c2 != 6'h3F)) ? c2 + 1 : ((~switch_in[2] & (c2 != 6'h00)) ? c2 - 1 : c2));
        c3 <= (reset) ? 6'h20 : ((switch_in[3] & (c3 != 6'h3F)) ? c3 + 1 : ((~switch_in[3] & (c3 != 6'h00)) ? c3 - 1 : c3));
        c4 <= (reset) ? 6'h20 : ((switch_in[4] & (c4 != 6'h3F)) ? c4 + 1 : ((~switch_in[4] & (c4 != 6'h00)) ? c4 - 1 : c4));
        c5 <= (reset) ? 6'h20 : ((switch_in[5] & (c5 != 6'h3F)) ? c5 + 1 : ((~switch_in[5] & (c5 != 6'h00)) ? c5 - 1 : c5));
        c6 <= (reset) ? 6'h20 : ((switch_in[6] & (c6 != 6'h3F)) ? c6 + 1 : ((~switch_in[6] & (c6 != 6'h00)) ? c6 - 1 : c6));
        c7 <= (reset) ? 6'h20 : ((switch_in[7] & (c7 != 6'h3F)) ? c7 + 1 : ((~switch_in[7] & (c7 != 6'h00)) ? c7 - 1 : c7));
    end
    always @(posedge clock) begin
        switch_out[0] <= (reset) ? 0 : ((c0 == 6'h00) ? 0 : ((c0 == 6'h3F) ? 1 : switch_out[0]));
        switch_out[1] <= (reset) ? 0 : ((c1 == 6'h00) ? 0 : ((c1 == 6'h3F) ? 1 : switch_out[1]));
        switch_out[2] <= (reset) ? 0 : ((c2 == 6'h00) ? 0 : ((c2 == 6'h3F) ? 1 : switch_out[2]));
        switch_out[3] <= (reset) ? 0 : ((c3 == 6'h00) ? 0 : ((c3 == 6'h3F) ? 1 : switch_out[3]));
        switch_out[4] <= (reset) ? 0 : ((c4 == 6'h00) ? 0 : ((c4 == 6'h3F) ? 1 : switch_out[4]));
        switch_out[5] <= (reset) ? 0 : ((c5 == 6'h00) ? 0 : ((c5 == 6'h3F) ? 1 : switch_out[5]));
        switch_out[6] <= (reset) ? 0 : ((c6 == 6'h00) ? 0 : ((c6 == 6'h3F) ? 1 : switch_out[6]));
        switch_out[7] <= (reset) ? 0 : ((c7 == 6'h00) ? 0 : ((c7 == 6'h3F) ? 1 : switch_out[7]));
    end
endmodule