module register_16bit (
    input clk,
    input clear_n,
    input load_enable,
    input [15:0] in_data,
    output reg [15:0] out
);always @(posedge clk) begin
    if (!clear_n) begin
        out <= 16'b0000000000000000;
    end else if (load_enable) begin
        out <= in_data;
    end
end

endmodule