module checksum_checker (
    input wire [3:0] data_in,
    input wire valid,
    output reg [3:0] checksum_out,
    output reg integrity_valid
);
    reg [3:0] checksum_temp;

    always @(posedge valid) begin
        checksum_temp = data_in[0] + data_in[1] + data_in[2] + data_in[3];
        checksum_out = checksum_temp;
        integrity_valid = (checksum_out == data_in) ? 1'b1 : 1'b0;
    end
endmodule