module top_module(
    input [3:0] MULTIPLICAND,
    input [3:0] MULTIPLIER,
    output reg [7:0] PRODUCT
);reg [3:0] m;
reg [7:0] p;

always @(*) begin
    p = 0;
    for (m = 0; m < 4; m = m + 1) begin
        if (MULTIPLIER[m] == 1) begin
            p = p + (MULTIPLICAND << m);
        end
    end
end

assign PRODUCT = p;

endmodule