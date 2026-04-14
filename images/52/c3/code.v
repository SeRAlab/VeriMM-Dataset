module parallel_to_serial_shift_register(
    input clk,
    input load,
    input shift_enable,
    input [7:0] parallel_data,
    output reg serial_out);always @(posedge clk) begin
    if (load) begin
        serial_out <= parallel_data[0];
    end
    else if (shift_enable) begin
        serial_out <= {serial_out, parallel_data[7]};
    end
end
endmodule