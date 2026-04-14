module top_module (
    input clk,
    input j,
    input k,
    output reg q
);

    // JK flip-flop logic
    always @(posedge clk) begin
        if (j && k) begin
            q <= ~q;
        end else if (j) begin
            q <= 1;
        end else if (k) begin
            q <= 0;
        end
    end

endmodule