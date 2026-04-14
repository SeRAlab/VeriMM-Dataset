module D_latch (
    input wire d,
    input wire en,
    output reg q,
    output reg q_n
);
    always @(d or en) begin
        if (en) begin
            q <= d;
        end
        // When enable is low, q retains its value
    end

    always @(q) begin
        q_n <= ~q;
    end
endmodule