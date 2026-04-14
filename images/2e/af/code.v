module shift_register (
    input wire clk,
    input wire shift_left,
    input wire shift_right,
    input wire load,
    input wire [7:0] parallel_in,
    output reg [7:0] data_out
);

always @(posedge clk) begin
    if (load) begin
        data_out <= parallel_in; // Load parallel data
    end else if (shift_left) begin
        data_out <= {data_out[6:0], 1'b0}; // Shift left
    end else if (shift_right) begin
        data_out <= {1'b0, data_out[7:1]}; // Shift right
    end
end

endmodule