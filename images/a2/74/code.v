module shift_register(
    input clk,
    input rst,
    input serial_in,
    output reg [7:0] parallel_out
);

always @(posedge clk) begin
    if (rst)
        parallel_out <= 0;
    else
        parallel_out <= {parallel_out[6:0], serial_in};
end

endmodule