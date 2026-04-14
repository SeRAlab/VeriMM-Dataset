module dac_24bit (
    input wire [23:0] data_in,
    input wire enable,
    output reg [23:0] data_out
);
    always @(*) begin
        if (enable) begin
            data_out = data_in;
        end else begin
            data_out = 24'b0; // Output 0 when not enabled
        end
    end
endmodule