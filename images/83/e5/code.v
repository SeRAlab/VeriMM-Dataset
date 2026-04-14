module register_4bit(
    input clk,
    input reset,
    input enable,
    input [3:0] data_in,
    output reg [3:0] data_out
);

always @(posedge clk) begin
    if (reset)
        data_out <= 4'b0;
    else if (enable)
        data_out <= data_in;
end

endmodule