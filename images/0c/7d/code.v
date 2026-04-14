module clock_gated_dff (
    input wire clk,
    input wire d,
    input wire ce,
    output reg q
);
    always @(posedge clk) begin
        if (ce) begin
            q <= d;
        end
    end
endmodule