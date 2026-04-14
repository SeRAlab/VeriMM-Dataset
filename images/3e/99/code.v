module bluetooth_packet_checker(
    input wire clk,
    input wire [7:0] packet,
    output reg valid
);
    reg [7:0] start_pattern = 8'b10101010;
    reg [7:0] end_pattern = 8'b11001100;

    always @(posedge clk) begin
        if (packet == start_pattern) begin
            valid <= 1'b1; // Start of valid packet
        end else if (packet == end_pattern) begin
            valid <= 1'b0; // End of valid packet
        end
    end
endmodule