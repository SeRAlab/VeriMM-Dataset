module top_module(
    input [22:0] b,
    input [22:0] e,
    input reset,
    input clk,
    output reg [22:0] q
);reg [22:0] r_b;
reg [22:0] r_e;
reg [46:0] r_c;
reg [22:0] rr_b;
reg [22:0] rr_e;

always @(posedge clk) begin
    if (reset) begin
        r_b <= 0;
        r_e <= 0;
    end
    else begin
        r_b <= b;
        r_e <= e;
    end
end

always @(posedge clk) begin
    if (reset) begin
        r_c <= 0;
        rr_b <= 0;
        rr_e <= 0;
    end
    else begin
        r_c <= r_b * {1'b0, r_e};
        rr_b <= r_b;
        rr_e <= r_e;
    end
end

always @(posedge clk) begin
    if (reset) begin
        q <= 0;
    end
    else begin
        q <= r_c[46:24] >> (23 - $countones(rr_e));
    end
end

endmodule