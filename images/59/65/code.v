module sr_latch (
    input wire s,
    input wire r,
    output reg q
);

    always @(*) begin
        if (s && !r) begin
            q <= 1;
        end else if (!s && r) begin
            q <= 0;
        end
    end

endmodule