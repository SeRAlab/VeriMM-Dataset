module complement(
    input [3:0] A,
    output reg [3:0] C
);

    always @(*) begin
        C = ~A + 4'b1;
    end

endmodule