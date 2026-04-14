module top_module(
    input clk,    // Clocks are used in sequential circuits
    input d,
    input aset,
    input areset,
    output reg q );reg j, k, q1, q2;

    // Pipeline stage 1
    always @(posedge clk) begin
        j <= ~d & ~q2;
        k <= d & ~q2;
        q1 <= j & q2 | ~k & q2;
    end

    // Pipeline stage 2
    always @(posedge clk) begin
        q2 <= aset ? 1'b1 : areset ? 1'b0 : q1;
    end

    // Output stage
    always @(posedge clk) begin
        q <= q2;
    end

endmodule