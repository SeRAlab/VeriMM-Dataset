module top_module(
    input [3:0] a,
    input [3:0] b,
    output reg eq,
    output reg ge8,
    output reg lt8
);reg [3:0] diff;
wire [3:0] abs_diff;

assign abs_diff = (diff < 0) ? -diff : diff;

always @(*) begin
    diff = a - b;
    if (diff == 0) begin
        eq = 1;
        ge8 = 0;
        lt8 = 0;
    end else if (abs_diff >= 8) begin
        eq = 0;
        ge8 = 1;
        lt8 = 0;
    end else begin
        eq = 0;
        ge8 = 0;
        lt8 = 1;
    end
end

endmodule