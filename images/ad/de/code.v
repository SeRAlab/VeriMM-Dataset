module shift_register_8bit(
    input clk,
    input reset,
    input data_in,
    output reg [7:0] data_out
);

always @(posedge clk or posedge reset) begin
    if (reset)
        data_out <= 8'b0;
    else
        data_out <= {data_out[6:0], data_in};
end

endmodule