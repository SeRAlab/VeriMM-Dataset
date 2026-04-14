module inv_lsb(
    input [1:0] data,
    output reg q
);

    always @(*) begin
        q = ~data[0];
    end

endmodule