module top_module(
    input signed [3:0] A,
    input signed [3:0] B,
    output reg GTE
);always @(*) begin
        if (A >= B) begin
            GTE = 1;
        end
        else begin
            GTE = 0;
        end
    end

endmodule