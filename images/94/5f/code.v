module priority_encoder (
    input [3:0] data,
    output reg [1:0] encoded
);

    always @(*) begin
        casez (data)
            4'b1???: encoded = 2'b11;
            4'b01??: encoded = 2'b10;
            4'b001?: encoded = 2'b01;
            4'b0001: encoded = 2'b00;
            default: encoded = 2'b00;
        endcase
    end

endmodule