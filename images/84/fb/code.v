module shift_register(
    input  clk,
    input  reset,
    input  serial_in,
    output reg [3:0] parallel_out
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        parallel_out <= 4'b0000;
    end else begin
        parallel_out <= {serial_in, parallel_out[3:1]};
    end
end

endmodule