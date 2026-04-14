module gated_dff (
    input wire clk,
    input wire enable,
    input wire d,
    output reg q
);
    always @(posedge clk) begin
        if (enable) begin
            q <= d;
        end
    end
endmodule