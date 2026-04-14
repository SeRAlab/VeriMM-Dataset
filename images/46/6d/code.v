module sr_flip_flop (
    input clk,
    input s,
    input r,
    output reg q
);

    always @(posedge clk) begin
        if (s && r) begin
            // Undefined behavior, keeping q unchanged
        end else if (s)
            q <= 1;
        else if (r)
            q <= 0;
    end

endmodule