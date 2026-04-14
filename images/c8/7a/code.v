module bitwise_and (
    input [3:0] DATA_IN,
    input [3:0] MASK,
    output reg [3:0] DATA_OUT
);

    always @(*) begin
        DATA_OUT = DATA_IN & MASK;
    end

endmodule