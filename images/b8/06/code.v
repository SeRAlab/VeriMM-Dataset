module parallel_load_reg(
    input clk,
    input rst_n,
    input load,
    input [7:0] data_in,
    output reg [7:0] data_out
);

always @(posedge clk) begin
    if (!rst_n)
        data_out <= 8'd0;
    else if (load)
        data_out <= data_in;
end

endmodule