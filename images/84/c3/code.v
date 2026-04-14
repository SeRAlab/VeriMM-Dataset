module top_module(
    input [3:0] a,
    output reg [3:0] abs_val
);always @(*) begin
        if (a[3] == 1) begin
            abs_val = ~a + 1;
        end else begin
            abs_val = a;
        end
    end

endmodule