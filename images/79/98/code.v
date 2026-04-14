module top_module(
    input [3:0] a,
    input [3:0] b,
    input mode,
    output reg [3:0] out,
    output reg overflow
);always @(*) begin
        if (mode == 0) begin // addition
            out = a + b;
            if (out > 15) begin
                overflow = 1;
                out = out - 16;
            end else begin
                overflow = 0;
            end
        end else begin // subtraction
            out = a - b;
            if (out < 0) begin
                overflow = 1;
                out = out + 16;
            end else begin
                overflow = 0;
            end
        end
    end

endmodule