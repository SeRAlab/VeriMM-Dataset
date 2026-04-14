module shift_register(
    input clk,
    input reset,
    input shift_enable,
    input [15:0] data_in,
    output reg [15:0] data_out
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            data_out <= 16'b0;
        end else if (shift_enable) begin
            data_out <= {1'b0, data_out[15:1]}; // Shift right and fill with 0
        end else begin
            data_out <= data_in; // Load data_in if not shifting
        end
    end
endmodule