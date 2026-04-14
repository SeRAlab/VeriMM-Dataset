module shift_register (
    input wire clk,
    input wire rstn,
    input wire serial_in,
    output reg [15:0] parallel_out
);

always @(posedge clk or negedge rstn) begin
    if (!rstn)
        parallel_out <= 16'b0;
    else
        parallel_out <= {parallel_out[14:0], serial_in};
end

endmodule