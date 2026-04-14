module checksum_checker (
    input wire clk,
    input wire reset,
    input wire valid,
    input wire [7:0] data_in,
    input wire [7:0] checksum_in,
    output reg [7:0] checksum_out,
    output reg data_valid
);

    reg [7:0] sum;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            sum <= 8'b0;
            checksum_out <= 8'b0;
            data_valid <= 1'b0;
        end else if (valid) begin
            sum <= sum + data_in;
            checksum_out <= sum % 256;
            data_valid <= (checksum_out == checksum_in);
        end
    end
endmodule