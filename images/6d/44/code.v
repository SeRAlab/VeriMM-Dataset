module top_module(
    input signed [15:0] a,
    input signed [15:0] b,
    input add_sub,
    output reg signed [15:0] out
);always @(*) begin
    if (add_sub == 1) begin
        if (a > 0 && b > 0 && (a + b) < 0) begin
            out = 32767;
        end else if (a < 0 && b < 0 && (a + b) > 0) begin
            out = -32768;
        end else begin
            out = a + b;
        end
    end else begin
        if (a > 0 && (-b) > 0 && (a - b) < 0) begin
            out = 32767;
        end else if (a < 0 && (-b) < 0 && (a - b) > 0) begin
            out = -32768;
        end else begin
            out = a - b;
        end
    end
end

endmodule