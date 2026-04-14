module shift_register_16bit (
    input clk,
    input serial_in,
    output reg [15:0] parallel_out
);

always @(posedge clk) begin
    parallel_out <= {serial_in, parallel_out[15:1]};
end

endmodule