module dff (
    input d,
    input en,
    input clk,
    input reset,
    output reg q
);always @(posedge clk or posedge reset) begin
    if (reset) begin
        q <= 1'b0;
    end else if (en) begin
        q <= d;
    end
end

endmodule