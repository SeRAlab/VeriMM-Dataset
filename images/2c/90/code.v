module checksum_checker (
    input wire clk,
    input wire [7:0] data_in,
    input wire [2:0] checksum_in,
    output reg valid
);
    reg [3:0] computed_checksum;

    always @(posedge clk) begin
        // Compute the checksum by summing the bits of data_in
        computed_checksum <= data_in[0] + data_in[1] + data_in[2] +
                             data_in[3] + data_in[4] + data_in[5] +
                             data_in[6] + data_in[7];
        // Compare computed checksum with the input checksum
        if (computed_checksum[2:0] == checksum_in) begin
            valid <= 1'b1; // Valid data
        end else begin
            valid <= 1'b0; // Invalid data
        end
    end
endmodule