module test_if (
    input [1:0] bad,
    output reg result
);

always @(*) begin
    if (bad[0] == 1 && bad[1] == 0) begin
        result = 1;
    end else begin
        result = 0;
    end
end

endmodule