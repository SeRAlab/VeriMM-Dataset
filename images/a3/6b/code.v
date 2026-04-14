module priority_encoder_5bit(
    input [4:0]         data_in   ,
    output reg [2:0]    binary_out
);

always @(*) begin
    casez (data_in)
        5'b1????: binary_out = 3'b100;
        5'b01???: binary_out = 3'b011;
        5'b001??: binary_out = 3'b010;
        5'b0001?: binary_out = 3'b001;
        5'b00001: binary_out = 3'b000;
        default: binary_out = 3'b000;
    endcase
end

endmodule