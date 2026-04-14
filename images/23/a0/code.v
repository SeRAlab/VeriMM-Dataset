module ip_checksum (
    input [15:0] data_in,
    input valid,
    input clk,
    input rst,
    output reg [15:0] checksum
);
    reg [15:0] sum;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            sum <= 16'b0;
            checksum <= 16'b0;
        end else if (valid) begin
            sum <= sum + data_in;
            if (sum[16]) begin // Check for overflow
                sum <= sum + 1; // Wrap around
            end
        end else begin
            checksum <= ~sum; // One's complement
        end
    end
endmodule