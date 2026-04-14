module checksum_generator (
    input wire clk,
    input wire reset,
    input wire [3:0] data_in,
    output reg [1:0] checksum_out
);

    reg [3:0] sum;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            checksum_out <= 2'b00;
            sum <= 4'b0000;
        end else begin
            sum <= sum + data_in;
            checksum_out <= sum[1:0]; // Take the last two bits of the sum
        end
    end
endmodule