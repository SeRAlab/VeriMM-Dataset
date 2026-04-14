module top_module(
    input signed [31:0] ivalue,
    input [4:0] amount,
    input clk,
    output reg signed [31:0] ovalue
);always @(posedge clk) begin
    ovalue <= ivalue << amount;
    if (ivalue < 0 && ovalue > 0) begin
        ovalue <= -2147483648; // handle overflow for negative input values
    end
    else if (ivalue > 0 && ovalue < 0) begin
        ovalue <= 2147483647; // handle overflow for positive input values
    end
end

endmodule