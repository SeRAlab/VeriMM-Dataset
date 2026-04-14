module dac_controller (
    input [23:0] data_in,
    input enable,
    output reg [11:0] data_out_high,
    output reg [11:0] data_out_low
);
    always @(*) begin
        if (enable) begin
            data_out_high = data_in[23:12]; // High 12 bits
            data_out_low = data_in[11:0];    // Low 12 bits
        end else begin
            data_out_high = 12'b0; // Default to zero when not enabled
            data_out_low = 12'b0;  // Default to zero when not enabled
        end
    end
endmodule