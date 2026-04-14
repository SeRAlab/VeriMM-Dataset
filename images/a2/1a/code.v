module priority_encoder_4bit(
    input  [3:0] req,
    output reg [1:0] code
);

always @(*) begin
    casez (req)
        4'b1???: code = 2'b11;
        4'b01??: code = 2'b10;
        4'b001?: code = 2'b01;
        4'b0001: code = 2'b00;
        default: code = 2'b00; // No request
    endcase
end

endmodule