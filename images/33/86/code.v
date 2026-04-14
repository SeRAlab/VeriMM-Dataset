module checksum_calculator (
    input wire clk,
    input wire reset,
    input wire [7:0] data_in,
    output reg [7:0] checksum_out
);
    reg [7:0] sum;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            sum <= 8'b0;
            checksum_out <= 8'b0;
        end else begin
            sum <= sum + data_in;
            checksum_out <= ~sum + 1'b1; // 2's complement
        end
    end
endmodule