module top_module(
    input wire clk,    // Added clk input
    input wire r1,
    input wire r2,
    input wire a1,
    input wire a2,
    output reg r0,
    output reg a0
);always @(posedge clk) begin
        if (r1 == 1'b0 && r2 == 1'b0) begin
            r0 <= 1'b0;
            a0 <= 1'b0;
        end else if (r1 == 1'b1 && r2 == 1'b0) begin
            r0 <= 1'b1;
            a0 <= a1;
        end else if (r1 == 1'b0 && r2 == 1'b1) begin
            r0 <= 1'b1;
            a0 <= a2;
        end else if (r1 == 1'b1 && r2 == 1'b1) begin
            r0 <= 1'b0;
            a0 <= 1'b0;
        end
    end

endmodule