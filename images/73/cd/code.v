module register_32bit(
    input clk,
    input reset,
    input [31:0] data_in,
    output reg [31:0] data_out
);

    // Always block triggered on the rising edge of the clock or reset signal
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            data_out <= 32'b0;  // Asynchronous reset to zero
        end else begin
            data_out <= data_in;  // Hold the input data
        end
    end

endmodule