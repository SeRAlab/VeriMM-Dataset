module dwt_haar (
    input [3:0] x0, x1, x2, x3,
    output reg [4:0] approx,
    output reg [4:0] detail
);
    always @(*) begin
        approx = (x0 + x1 + x2 + x3) >> 2; // Average
        detail = (x0 - x2) + (x1 - x3);     // Detail
    end
endmodule