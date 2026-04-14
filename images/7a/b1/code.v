module top_module(
    input [7:0] data_in,
    output reg [2:0] encoded_out);always @(*) begin
        casez (data_in)
            8'b1???????: encoded_out = 3'b111;
            8'b01??????: encoded_out = 3'b110;
            8'b001?????: encoded_out = 3'b101;
            8'b0001????: encoded_out = 3'b100;
            8'b00001???: encoded_out = 3'b011;
            8'b000001??: encoded_out = 3'b010;
            8'b0000001?: encoded_out = 3'b001;
            8'b00000001: encoded_out = 3'b000;
            default: encoded_out = 3'b000;
        endcase
    end

endmodule