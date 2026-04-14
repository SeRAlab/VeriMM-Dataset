module preset_register (
    input clk,
    input preset,
    input load_enable,
    input [11:0] in_data,
    output reg [11:0] out
);parameter PRESET_VALUE = 12'b101010101010;

always @(posedge clk) begin
    if (preset) begin
        out <= PRESET_VALUE;
    end else if (load_enable) begin
        out <= in_data;
    end
end

endmodule