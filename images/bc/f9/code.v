module top_module(
    input clk,
    input d,
    output reg q );reg s, r, s_pipe, r_pipe;

    always @(posedge clk) begin
        s <= d;
        r <= ~d;
    end

    always @(posedge clk) begin
        s_pipe <= s;
        r_pipe <= r;
    end

    always @(posedge clk) begin
        q <= s_pipe & ~q;
        q <= r_pipe | q;
    end

endmodule