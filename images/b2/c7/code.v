module shift_reg_16bit(
    input clk,
    input load,
    input [15:0] data_in,
    output reg [15:0] data_out
);

always @(posedge clk) begin
    if (load)
        data_out <= data_in;
    else
        data_out <= {data_out[14:0], 1'b0};
end

endmodule