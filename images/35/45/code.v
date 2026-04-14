module power_gating (
    input [1:0] ctrl,
    input [3:0] data_in,
    output reg [3:0] data_out
);

    always @(*) begin
        case (ctrl)
            2'b11: data_out = data_in; // Power on
            2'b00: data_out = 4'b0000;  // Power off
            default: data_out = 4'bXXXX; // Unknown state
        endcase
    end
endmodule