module checksum_calculator(
    input clk,
    input rst,
    input [7:0] data_in,
    input data_valid,
    input last_word,
    output reg [7:0] checksum_out,
    output reg checksum_valid
);
    reg [7:0] checksum;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            checksum <= 8'b0;
            checksum_out <= 8'b0;
            checksum_valid <= 0;
        end else if (data_valid) begin
            checksum <= checksum + data_in;
            if (last_word) begin
                checksum_out <= checksum;
                checksum_valid <= 1;
            end
        end
    end
endmodule