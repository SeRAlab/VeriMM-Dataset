module shift_register(
    input  clk,
    input  rst,
    input  [3:0] data_in,
    output reg [3:0] data_out
);

always @(posedge clk) begin
    if (rst)
        data_out <= 4'b0000;
    else
        data_out <= {data_out[2:0], data_in[3]};
end

endmodule