module register_16bit(
    input clk,
    input reset,
    input [15:0] data_in,
    output reg [15:0] data_out
);

    // Always block triggered on the rising edge of the clock
    always @(posedge clk) begin
        if (reset) begin
            data_out <= 16'b0;  // Synchronous reset to zero
        end else begin
            data_out <= data_in;  // Hold the input data otherwise
        end
    end

endmodule