module priority_encoder_8bit(
    input wire [7:0] data_in,
    output reg [2:0] position
    );

always @(*) begin
    casez (data_in)
        8'b1???????: position = 3'd7;
        8'b01??????: position = 3'd6;
        8'b001?????: position = 3'd5;
        8'b0001????: position = 3'd4;
        8'b00001???: position = 3'd3;
        8'b000001??: position = 3'd2;
        8'b0000001?: position = 3'd1;
        8'b00000001: position = 3'd0;
        default: position = 3'd0;
    endcase
end

endmodule