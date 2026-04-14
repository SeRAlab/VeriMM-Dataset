module register_with_enable (
    input clk,
    input enable,
    input [3:0] d,
    output reg [3:0] q
);

    always @(posedge clk) begin
        if (enable) begin
            q <= d;
        end
    end

endmodule