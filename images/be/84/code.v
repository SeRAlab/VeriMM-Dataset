module top_module(clk, rst, valid, i0, i1, o0, o1);input clk, rst;
input [63:0] i0, i1;
output valid;
output [31:0] o0, o1;

reg valid;
reg [31:0] o0, o1;

reg [3:0] k;
reg [31:0] add1, add2, sub1, sub2, sub2_c;
reg [64:0] real_, imag_;

always@(posedge clk or posedge rst) begin
    if(rst) begin
        o0 = 0; o1 = 0; k = 0; valid = 0;
    end else begin
        add1 = i0[63:32] + i1[63:32];
        add2 = i0[31:0] + i1[31:0];
        o0 = {add1[23:8], add2[23:8]};

        sub1 = i0[63:32] - i1[63:32];
        sub2 = i0[31:0] - i1[31:0];
        sub2_c = 0 - sub2;
        real_ = {{32{sub1[31]}}, sub1} * {32'h0000, 32'h00010000} + {{32{sub2_c[31]}}, sub2_c} * {32'h0000, 32'h00000000};
        imag_ = {{32{sub1[31]}}, sub1} * {32'h0000, 32'h00000000} + {{32{sub2[31]}}, sub2} * {32'h0000, 32'h00010000};
        o1 = {real_[39:24], imag_[39:24]};

        if(k == 1) valid = 1;
        else valid = 0;

        if(o0 || o1) k = k + 1;
        else k = k;
    end
end


endmodule