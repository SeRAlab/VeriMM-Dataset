module checksum_calculator (
    input clk,
    input enable,
    input [4:0] data_in,
    output reg [4:0] checksum_out
);
    always @(posedge clk) begin
        if (enable) begin
            checksum_out <= (checksum_out + data_in) % 32;
        end
    end
endmodule