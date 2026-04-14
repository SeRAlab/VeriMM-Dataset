module shift_register(
    input wire clk,
    input wire serial_in,
    input wire load,
    input wire [3:0] parallel_in,
    output reg [3:0] parallel_out
    );

always @(posedge clk) begin
    if (load)
        parallel_out <= parallel_in;
    else
        parallel_out <= {serial_in, parallel_out[3:1]};
end

endmodule