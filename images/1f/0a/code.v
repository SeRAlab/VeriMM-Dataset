module checksum_calculator (
    input [7:0] data,
    input enable,
    output reg [7:0] checksum
);
    always @(*) begin
        if (enable) begin
            checksum = data[0] + data[1] + data[2] + data[3] + data[4] + data[5] + data[6] + data[7];
        end
    end
endmodule