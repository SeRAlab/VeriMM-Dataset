module checksum_checker(
    input wire clk,
    input wire rst,
    input wire [7:0] data_in,
    input wire [7:0] checksum_in,
    input wire validate,
    output reg [7:0] checksum_out,
    output reg valid
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            checksum_out <= 8'b0;
            valid <= 0;
        end else begin
            checksum_out <= checksum_out + data_in;
            if (validate) begin
                if (checksum_out == checksum_in) begin
                    valid <= 1;
                end else begin
                    valid <= 0;
                end
            end
        end
    end
endmodule