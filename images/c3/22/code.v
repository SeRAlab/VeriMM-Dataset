module dff_async_reset_enable (
    input A1,
    input A2,
    input B1,
    input clk,
    input reset_n,
    input enable,
    output reg X
);

always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        X <= 0;
    end else if (enable) begin
        X <= A1 & A2;
    end
end

endmodule