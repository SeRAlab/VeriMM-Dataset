module comparator (
    input [7:0] a,
    input [7:0] b,
    output reg eq
);

    always @(*) begin
        if (a == b) begin
            eq = 1;
        end else begin
            eq = 0;
        end
    end

endmodule