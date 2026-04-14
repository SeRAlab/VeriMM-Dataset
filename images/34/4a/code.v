module clock_gated_dff (
    input wire clk,
    input wire rst,
    input wire enable,
    input wire d,
    output reg q
);

always @(posedge clk) begin
    if (rst) begin
        q <= 1'b0;
    end else if (enable) begin
        q <= d;
    end
end

endmodule