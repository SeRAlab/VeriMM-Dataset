module register_with_sync_reset (
    input clk,
    input rst,
    input [15:0] data_in,
    output reg [15:0] data_out);

    always @(posedge clk) begin
        if (rst) begin
            data_out <= 16'b0;
        end else begin
            data_out <= data_in;
        end
    end
endmodule