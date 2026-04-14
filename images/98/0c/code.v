module priority_encoder_3bit(
    input  [2:0] data_in,

    output reg [1:0] pos_out
);

always @(*) begin
    casez (data_in)
        3'b1??: pos_out = 2'b10;
        3'b01?: pos_out = 2'b01;
        3'b001: pos_out = 2'b00;
        default: pos_out = 2'b00;
    endcase
end

endmodule