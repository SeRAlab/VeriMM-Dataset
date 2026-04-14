module load_register (
    input clk,
    input reset,
    input enable,
    input [3:0] in_data,
    output reg [3:0] out
);always @(posedge clk) begin
    if (reset) begin
        out <= 4'b0000;
    end else if (enable) begin
        out <= in_data;
    end
end

endmodule