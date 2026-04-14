module top_module(
    q,
    clk,
    d,
    reset_b
);output q;
    input clk;
    input d;
    input reset_b;

    reg q;

    always @(posedge clk or negedge reset_b) begin
        if (~reset_b) begin
            q <= 1'b0;
        end else begin
            q <= d;
        end
    end

endmodule