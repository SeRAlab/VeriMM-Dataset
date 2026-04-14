module DAC (
    input [7:0] data_in,
    input [2:0] scale_ctrl,
    output reg [7:0] data_out
);
    always @(*) begin
        case (scale_ctrl)
            3'b000: data_out = data_in;          // 1x scaling
            3'b001: data_out = data_in << 1;     // 2x scaling
            3'b010: data_out = data_in << 2;     // 4x scaling
            default: data_out = 8'b00000000;      // Default case to avoid latches
        endcase
        // Ensure output does not exceed 8 bits
        data_out = (data_out > 8'hFF) ? 8'hFF : data_out;
    end
endmodule