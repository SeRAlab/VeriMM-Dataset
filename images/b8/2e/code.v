module circular_shift_register
(
    input clk,
    input reset,
    input [9:0] data_in,
    output reg [9:0] data_out
);

    always @(posedge clk) begin
        if (reset) begin
            data_out <= 10'b0000000000; // Reset shift register to 0000000000
        end else begin
            data_out <= {data_out[8:0], data_out[9]}; // Rotate left
        end
    end

endmodule