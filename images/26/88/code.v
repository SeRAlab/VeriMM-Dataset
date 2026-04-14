module checksum_generator_checker (
    input wire clk,
    input wire rst,
    input wire [7:0] data_in,
    input wire [7:0] checksum_in,
    output reg [7:0] checksum_out,
    output reg valid
);
    reg [7:0] sum;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            sum <= 8'b0;
            checksum_out <= 8'b0;
            valid <= 1'b0;
        end else begin
            sum <= sum + data_in;
            checksum_out <= sum;
            if (checksum_out == checksum_in) begin
                valid <= 1'b1;
            end else begin
                valid <= 1'b0;
            end
        end
    end
endmodule