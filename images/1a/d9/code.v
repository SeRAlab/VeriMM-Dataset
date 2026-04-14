module power_gating (
    input [1:0] ctrl,
    input [4:0] data_in,
    output reg [4:0] data_out
);
    always @(*) begin
        case (ctrl)
            2'b00: data_out = data_in; // Active mode
            2'b01: data_out = data_in; // Active mode
            2'b10: data_out = 5'b00000; // Sleep mode
            2'b11: data_out = 5'b00000; // Sleep mode
            default: data_out = 5'b00000; // Default case
        endcase
    end
endmodule