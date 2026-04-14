module top_module(
    input clkvga,
    output reg active,
    output reg hs = 0,
    output reg vs = 0,
    output reg[10:0] hc = 0,
    output reg[10:0] vc = 0
    );parameter width = 800;
parameter height = 600;
parameter H_FP = 56;
parameter H_PW = 120;
parameter H_MAX = 1040;
parameter V_FP = 37;
parameter V_PW = 6;
parameter V_MAX = 666;

always @(posedge clkvga) begin
    hc <= (hc == H_MAX - 1) ? 0 : hc + 1;
    if((hc == (H_MAX - 1)) && (vc == (V_MAX - 1)))
        vc <= 0;
    else if(hc == (H_MAX - 1))
        vc <= vc + 1;
    hs <= (hc >= (H_FP + width - 1)) && (hc < (H_FP + width + H_PW - 1)) ? 1 : 0;
    vs <= (vc >= (V_FP + height - 1)) && (vc < (V_FP + height + V_PW - 1)) ? 1 : 0;
    active <= (hc < width && vc < height);
end
endmodule