module reg_32bit(
    input clk,
    input reset,
    input enable,
    input [31:0] data_in,
    output reg [31:0] data_out
);

always @(posedge clk) begin
    if (reset)
        data_out <= 32'b0;
    else if (enable)
        data_out <= data_in;
end

endmodule