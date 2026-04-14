module top_module(
    input clk,
    input d,
    output reg q );reg t;

    always @(posedge clk) begin
        t <= d;
    end

    always @(posedge clk) begin
        if (t) begin
            q <= ~q;
        end
    end

endmodule