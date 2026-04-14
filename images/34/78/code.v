module power_gating_control (
    input wire enable,
    input wire [3:0] data,
    output reg [3:0] output_data,
    output reg power_gated
);

always @(*) begin
    if (enable) begin
        output_data = data;
        power_gated = 1'b1;
    end else begin
        output_data = 4'b0000;
        power_gated = 1'b0;
    end
end

endmodule