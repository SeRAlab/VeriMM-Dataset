module four_input_one_output (
    input a,
    input b,
    input c,
    input d,
    output reg out
);

always @(*) begin
    if (a) begin
        out = 1;
    end else if (b) begin
        out = 1;
    end else if (c) begin
        out = 1;
    end else if (d) begin
        out = 1;
    end else begin
        out = 0;
    end
end

endmodule