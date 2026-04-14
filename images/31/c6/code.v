module checksum_calculator (
    input [7:0] data_in,
    input valid,
    output reg [7:0] checksum_out
);
    always @(*) begin
        if (valid) begin
            checksum_out = data_in; // Initialize checksum with data
        end else begin
            checksum_out = 8'b0; // Reset checksum if not valid
        end
    end
endmodule