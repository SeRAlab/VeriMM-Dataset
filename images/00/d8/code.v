module crc_generator (
    input [3:0] data,
    input clk,
    input reset,
    output reg [3:0] crc
);
    reg [3:0] temp;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            crc <= 4'b0000;
            temp <= data;
        end else begin
            crc[3] <= temp[3] ^ temp[2];
            crc[2] <= temp[2] ^ temp[1];
            crc[1] <= temp[1] ^ temp[0];
            crc[0] <= temp[0] ^ (temp[3] ^ temp[1]);
            temp <= {temp[2:0], 1'b0}; // Shift left
        end
    end
endmodule