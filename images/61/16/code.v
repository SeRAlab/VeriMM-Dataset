module shift_register(
    input clk,
    input rst,
    input serial_in,
    output reg [3:0] parallel_out
);

always @(posedge clk or posedge rst) begin
    if (rst)
        parallel_out <= 4'b0000;
    else
        parallel_out <= {serial_in, parallel_out[3:1]};
end

endmodule