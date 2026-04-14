module parallel_to_serial(
    input clk,
    input reset,
    input [7:0] data_in,
    output reg serial_out
);
    reg [2:0] bit_index;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            serial_out <= 1'b0;
            bit_index <= 3'd0;
        end else begin
            serial_out <= data_in[bit_index];
            bit_index <= bit_index + 1;
        end
    end
endmodule