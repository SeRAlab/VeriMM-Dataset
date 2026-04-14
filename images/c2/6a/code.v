module dffsr_async_clear_set_reset(clk, d, set, reset, clear, q, q_bar);
    input clk, d, set, reset, clear;
    output q, q_bar;
    reg q, q_bar;

    always @(posedge clk) begin
        if (clear) begin
            q <= 0;
            q_bar <= 1;
        end else if (set) begin
            q <= 1;
            q_bar <= 0;
        end else if (reset) begin
            q <= 0;
            q_bar <= 1;
        end else begin
            q <= d;
            q_bar <= ~d;
        end
    end

endmodule