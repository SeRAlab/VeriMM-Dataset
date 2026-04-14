module register_16bit(
    input clk,
    input reset,
    input [15:0] data_in,
    output reg [15:0] data_out
);

always @(posedge clk or posedge reset) begin
    if (reset)
        data_out <= 16'b0;
    else
        data_out <= data_in;
end

endmodule