module top_module(
    input clk,
    input reset,
    input parallel_load,
    input shift_right,
    input shift_left,
    input [3:0] parallel_data,
    output reg [3:0] serial_data
);always @(posedge clk) begin
    if (reset) begin
        serial_data <= 4'b0;
    end
    else if (parallel_load) begin
        serial_data <= parallel_data;
    end
    else if (shift_right) begin
        serial_data <= {serial_data[0], serial_data[3:1]};
    end
    else if (shift_left) begin
        serial_data <= {serial_data[2:0], serial_data[3]};
    end
end

endmodule