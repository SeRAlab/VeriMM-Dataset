module top_module(
    input a,
    input b,
    input c,
    output y
);reg yi;

    always @(*) begin
        if (a | (b & c)) begin
            yi <= 1;
        end else if (a == 0 && b == 0 && c == 0) begin
            yi <= 0;
        end
    end

    assign y = yi;

endmodule