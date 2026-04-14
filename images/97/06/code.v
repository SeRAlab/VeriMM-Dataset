module top_module(
    input clk,
    input d,
    output reg q );reg d1, d2, d3;
    reg q1, q2, q3;

    always @(posedge clk) begin
        d1 <= d;
        q1 <= q;
    end

    always @(posedge clk) begin
        d2 <= d1;
        q2 <= q1;
    end

    always @(posedge clk) begin
        d3 <= d2;
        q3 <= q2;
    end

    always @(posedge clk) begin
        q <= q3;
    end

endmodule