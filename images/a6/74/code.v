module reg_16bit(
    input clk,
    input clear,
    input load,
    input [15:0] data_in,
    output reg [15:0] data_out
);

always @(posedge clk or posedge clear) begin
    if (clear)
        data_out <= 16'b0;
    else if (load)
        data_out <= data_in;
end

endmodule