module checksum_calculator (
    input [3:0] data_in,
    input calculate,
    output reg [3:0] checksum_out
);
    always @(*) begin
        if (calculate) begin
            checksum_out = data_in[3] ^ data_in[2] ^ data_in[1] ^ data_in[0];
        end else begin
            checksum_out = 4'b0000; // No operation
        end
    end
endmodule