module priority_encoder_4to2(
    input  [3:0] data_in,
    output reg [1:0] data_out
);

always @(*) begin
    casez (data_in)
        4'b1??? : data_out = 2'b11;
        4'b01?? : data_out = 2'b10;
        4'b001? : data_out = 2'b01;
        4'b0001 : data_out = 2'b00;
        default : data_out = 2'b00;
    endcase
end

endmodule