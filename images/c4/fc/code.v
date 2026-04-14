module twos_comp (
    input [3:0] D,
    output reg [3:0] C
);

    always @(*) begin
        C = ~D + 1;
    end

endmodule