module twos_comp(
    input signed [3:0] a,
    output reg signed [3:0] b
);

always @(*) begin
    if (a[3] == 0) begin // positive number
        b = a;
    end else begin // negative number
        b = ~a + 1;
    end
end

endmodule