module data_latch16 (
    input clk,
    input reset,
    input [15:0] data_in,
    output reg [15:0] data_out
);

    always @(negedge clk or posedge reset) begin
        if (reset) begin
            data_out <= 16'b0;
        end else begin
            data_out <= data_in;
        end
    end
endmodule