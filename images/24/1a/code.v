module dac_controller (
    input [3:0] select,
    output reg [15:0] analog_output
);

always @(*) begin
    case (select)
        4'd0: analog_output = 16'h0000; // 0
        4'd1: analog_output = 16'h0FFF; // 4095
        4'd2: analog_output = 16'h1FFF; // 8191
        4'd3: analog_output = 16'h2FFF; // 12287
        4'd4: analog_output = 16'h3FFF; // 16383
        4'd5: analog_output = 16'h4FFF; // 20479
        4'd6: analog_output = 16'h5FFF; // 24575
        4'd7: analog_output = 16'h6FFF; // 28671
        4'd8: analog_output = 16'h7FFF; // 32767
        4'd9: analog_output = 16'h8FFF; // 36863
        4'd10: analog_output = 16'h9FFF; // 40959
        4'd11: analog_output = 16'hAFFF; // 45055
        4'd12: analog_output = 16'hBFFF; // 49151
        4'd13: analog_output = 16'hCFFF; // 53247
        4'd14: analog_output = 16'hDFFF; // 57343
        4'd15: analog_output = 16'hFFFF; // 65535
        default: analog_output = 16'h0000; // Default case
    endcase
end

endmodule