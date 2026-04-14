module top_module (
    input set,
    input reset,
    output reg q
);

    always @(*) begin
        if (reset) begin
            q <= 1'b0;
        end else if (set) begin
            q <= 1'b1;
        end
    end

endmodule