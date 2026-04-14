module top_module (
    input d,
    input enable,
    input reset,
    output reg q
);

    always @(*) begin
        if (reset) begin
            q <= 1'b0;
        end else if (enable) begin
            q <= d;
        end
    end

endmodule