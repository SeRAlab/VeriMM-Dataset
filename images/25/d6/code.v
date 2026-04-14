module checksum_calc (
    input wire clk,
    input wire rst,
    input wire [7:0] data_in,
    output reg [7:0] checksum_out
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        checksum_out <= 8'b0;
    end else begin
        checksum_out <= (checksum_out + data_in) % 256;
    end
end

endmodule