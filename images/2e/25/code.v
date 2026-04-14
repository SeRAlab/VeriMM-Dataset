module power_gating (
    input [1:0] ctrl,
    input [3:0] data,
    output reg [3:0] gated_output
);
    always @(*) begin
        case (ctrl)
            2'b00: gated_output = 4'b0000; // Power gated off
            2'b01: gated_output = data;     // Power on, pass data
            2'b10: gated_output = data;     // Power on, pass data
            2'b11: gated_output = 4'b0000; // Power gated off
            default: gated_output = 4'b0000; // Default case
        endcase
    end
endmodule