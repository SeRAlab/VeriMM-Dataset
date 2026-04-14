module crc_generator (
    input wire clk,
    input wire reset,
    input wire data_in,
    output reg [15:0] crc_out
);
    reg [15:0] crc; // CRC register

    // Polynomial: x^16 + x^12 + x^5 + 1 (0xA001)
    wire feedback;

    // Feedback is the last bit of the CRC
    assign feedback = crc[15] ^ data_in;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            crc <= 16'hFFFF; // Initialize CRC to all ones
        end else begin
            crc <= {crc[14:0], 1'b0} ^ (feedback ? 16'hA001 : 16'h0000);
        end
    end

    always @(posedge clk) begin
        crc_out <= crc;
    end
endmodule