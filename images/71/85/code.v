module register_8bit(
    input [7:0] d,
    input clk,
    input ld,
    output reg [7:0] q
);
    always @(posedge clk) begin
        if (ld)
            q <= d;
    end
endmodule