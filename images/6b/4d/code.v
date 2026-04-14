module priority_encoder(
    input [3:0] data_in,
    output reg [1:0] priority_out
);
    always @(*) begin
        casez (data_in)
            4'b1???: priority_out = 2'b11;
            4'b01??: priority_out = 2'b10;
            4'b001?: priority_out = 2'b01;
            4'b0001: priority_out = 2'b00;
            default: priority_out = 2'b00;
        endcase
    end
endmodule