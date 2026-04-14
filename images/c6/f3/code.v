module absolute_value (
    input signed [15:0] in,
    output reg [15:0] out
);

    always @(*) begin
        if (in < 0) begin
            out = ~in + 1;
        end else begin
            out = in;
        end
    end

endmodule