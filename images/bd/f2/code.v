module sr_latch (
    input wire s,
    input wire r,
    input wire rst_n,
    output reg q
);

    always @(*) begin
        if (!rst_n) begin
            q <= 1'b0;
        end else if (s && !r) begin
            q <= 1'b1;
        end else if (!s && r) begin
            q <= 1'b0;
        end
    end

endmodule