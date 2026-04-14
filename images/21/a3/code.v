module checksum (
    input wire [4:0] data_in,
    input wire clk,
    output reg [2:0] checksum_out
);

    always @(posedge clk) begin
        checksum_out <= (data_in[0] + data_in[1] + data_in[2] + data_in[3] + data_in[4]) % 8;
    end

endmodule