module checksum (
    input wire clk,
    input wire reset,
    input wire [4:0] data,
    output reg [4:0] checksum_out,
    output reg checksum_valid
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            checksum_out <= 5'b0;
            checksum_valid <= 1'b0;
        end else begin
            checksum_out <= data[0] ^ data[1] ^ data[2] ^ data[3] ^ data[4]; // XOR for checksum
            checksum_valid <= 1'b1;
        end
    end
endmodule