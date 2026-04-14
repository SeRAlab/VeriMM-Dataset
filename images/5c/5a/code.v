module reg32_sync
(
    input clk,
    input load,
    input clear,
    input [31:0] data_in,
    output reg [31:0] data_out
);

always @(posedge clk) begin
    if (clear)
        data_out <= 32'd0;
    else if (load)
        data_out <= data_in;
end

endmodule