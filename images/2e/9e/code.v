module ip_checksum (
    input [15:0] data_in,
    input valid,
    output reg [15:0] checksum,
    input clk,
    input reset
);
    reg [15:0] sum;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            sum <= 16'b0;
            checksum <= 16'b0;
        end else if (valid) begin
            sum <= sum + data_in;
        end
    end

    always @(posedge clk) begin
        if (!valid) begin
            checksum <= ~sum; // one's complement of the sum
        end
    end
endmodule