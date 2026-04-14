module data_forwarding_unit (
    input [4:0] data1,
    input [4:0] data2,
    input [1:0] forward_signal,
    output reg [4:0] forwarded_data
);
    always @(*) begin
        case (forward_signal)
            2'b00: forwarded_data = data1;
            2'b01: forwarded_data = data2;
            2'b10: forwarded_data = data1 + data2;
            2'b11: forwarded_data = 5'b00000;
            default: forwarded_data = 5'b00000;
        endcase
    end
endmodule