module prio_encoder(
    input [7:0] req_in,
    output reg [2:0] code_out
);

always @(*) begin
    casez(req_in)
        8'b1???????: code_out = 3'b111;
        8'b01??????: code_out = 3'b110;
        8'b001?????: code_out = 3'b101;
        8'b0001????: code_out = 3'b100;
        8'b00001???: code_out = 3'b011;
        8'b000001??: code_out = 3'b010;
        8'b0000001?: code_out = 3'b001;
        8'b00000001: code_out = 3'b000;
        default: code_out = 3'b000;
    endcase
end

endmodule