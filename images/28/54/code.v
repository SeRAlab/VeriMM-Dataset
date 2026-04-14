module ofdm_modulator (
    input clk,
    input reset,
    input [3:0] data_in,
    output reg [15:0] data_out
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            data_out <= 16'b0;
        end else begin
            data_out <= 16'b0; // Clear output
            data_out[data_in] <= 1'b1; // Set the corresponding position
        end
    end
endmodule