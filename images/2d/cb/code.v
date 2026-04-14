module checksum_checker (
    input clk,
    input rst,
    input [31:0] data_in,
    output reg [7:0] checksum_out
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            checksum_out <= 8'b0;
        end else begin
            checksum_out <= (checksum_out + data_in[7:0] + data_in[15:8] + data_in[23:16] + data_in[31:24]) % 256;
        end
    end
endmodule