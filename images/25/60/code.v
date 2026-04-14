module shift_register (
    input clk,
    input load,
    input [3:0] data_in,
    output reg [3:0] data_out
);

always @(posedge clk) begin
    if (load) begin
        data_out <= data_in;  // Parallel load
    end else begin
        data_out <= {data_out[2:0], 1'b0};  // Shift left and fill LSB with 0
    end
end

endmodule