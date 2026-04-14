module checksum_generator (
    input wire clk,
    input wire reset,
    input wire [7:0] data_in,
    input wire [7:0] checksum_in,
    output reg checksum_valid,
    output reg [7:0] checksum_out
);
    reg [7:0] checksum;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            checksum <= 8'd0;
            checksum_out <= 8'd0;
            checksum_valid <= 1'b0;
        end else begin
            checksum <= checksum + data_in; // accumulate checksum
            checksum_out <= checksum; // update output checksum
            if (checksum_out == checksum_in) begin
                checksum_valid <= 1'b1; // valid checksum
            end else begin
                checksum_valid <= 1'b0; // invalid checksum
            end
        end
    end
endmodule