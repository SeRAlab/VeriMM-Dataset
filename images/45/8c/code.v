module sr_latch (
    input s,
    input r,
    output reg q,
    output reg q_bar
);

    always @ (*) begin
        if (s && !r) begin
            q <= 1;
            q_bar <= 0;
        end else if (!s && r) begin
            q <= 0;
            q_bar <= 1;
        end
    end

endmodule