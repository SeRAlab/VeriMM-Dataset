module twos_complement (
    input [3:0] a,
    output reg [3:0] twos_comp
);

    always @(*) begin
        twos_comp = ~a + 1;
    end

endmodule