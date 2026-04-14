module top_module(
    input clk,
    input enable,
    input [11:0] data_in,
    output reg [11:0] data_out
);

    // Always block triggered on the rising edge of the clock
    always @(posedge clk) begin
        if (enable) begin
            data_out <= {data_out[10:0], data_in[11]};  // Shift left and load data_in[11] to LSB
        end
    end

endmodule