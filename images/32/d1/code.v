module power_gating (
    input [1:0] ctrl,
    input [3:0] data_in,
    output reg [3:0] data_out
);

always @(*) begin
    case (ctrl)
        2'b00: data_out = 4'b0000; // Power gated (off)
        2'b01: data_out = data_in; // Data is passed through
        2'b10: data_out = 4'b0000; // Power gated (off)
        2'b11: data_out = data_in; // Data is passed through
        default: data_out = 4'b0000; // Default case, power gated (off)
    endcase
end

endmodule