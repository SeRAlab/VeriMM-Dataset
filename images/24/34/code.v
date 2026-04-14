module checksum_checker (
    input clk,
    input rst,
    input [7:0] data_in,
    input valid,
    output reg [3:0] checksum_out,
    output reg integrity_flag
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            checksum_out <= 4'b0000;
            integrity_flag <= 1'b0;
        end else begin
            if (valid) begin
                // Calculate checksum
                checksum_out <= (data_in[0] + data_in[1] + data_in[2] + data_in[3] +
                                 data_in[4] + data_in[5] + data_in[6] + data_in[7]) % 16;
                // Assuming we receive checksum as last 4 bits of data_in
                integrity_flag <= (checksum_out == data_in[7:4]) ? 1'b1 : 1'b0;
            end
        end
    end
endmodule