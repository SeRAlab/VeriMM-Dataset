module checksum_validator (
    input wire clk,
    input wire reset,
    input wire enable,
    input wire [7:0] data_in,
    output reg checksum_valid
);
    reg [3:0] checksum;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            checksum <= 0;
            checksum_valid <= 0;
        end else if (enable) begin
            checksum <= data_in[0] + data_in[1] + data_in[2] + data_in[3] + 
                         data_in[4] + data_in[5] + data_in[6] + data_in[7];
            checksum_valid <= (checksum % 2 == 0);
        end
    end
endmodule