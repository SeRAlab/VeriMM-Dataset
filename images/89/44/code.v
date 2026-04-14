module top_module(
    q,
    q_n,
    d,
    reset,
    clk
);output q;
    output q_n;
    input d;
    input reset;
    input clk;

    reg q;
    wire q_n;

    always @(posedge clk or negedge reset) begin
        if (!reset) begin
            q <= 0;
        end else begin
            q <= d;
        end
    end

    assign q_n = ~q;

endmodule