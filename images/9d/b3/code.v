module top_module(
    input [8:0] H,
    input [7:0] S,V,
    output reg o  
);reg [8:0] u_h, l_h;
reg [7:0] u_s,u_v,l_s,l_v;

always @(H,S,V) begin
    if (l_h <= H && H <= u_h && l_s <= S && S <= u_s && l_v <= V && V <= u_v) begin
        o <= 1'd1;
    end else begin
        o <= 1'd0;
    end
end
endmodule