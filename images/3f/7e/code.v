module crc_generator(
    input [3:0] data_in,
    input clk,
    input rst,
    output reg [3:0] crc_out
);
    reg [3:0] crc;
    wire [4:0] data_with_crc;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            crc <= 4'b0000;
        end else begin
            {crc[3], crc[2], crc[1], crc[0]} <= {data_in[3], data_in[2], data_in[1], data_in[0]} ^ {crc[2], crc[1], crc[0], 1'b0};
        end
    end

    assign data_with_crc = {data_in, crc};

    always @(posedge clk) begin
        crc_out <= crc;
    end
endmodule