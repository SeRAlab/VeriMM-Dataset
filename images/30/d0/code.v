module ip_checksum (
    input [15:0] data_in,
    input valid,
    input clk,
    input reset,
    output reg [15:0] checksum,
    output reg done
);
    reg [15:0] sum;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            sum <= 16'h0000;
            checksum <= 16'h0000;
            done <= 0;
        end else if (valid) begin
            sum <= sum + data_in;
            // If sum exceeds 16 bits, wrap around (one's complement)
            if (sum[16]) begin
                sum <= sum[15:0] + 1;
            end
        end else begin
            // When processing is done, compute checksum
            checksum <= ~sum;  // One's complement of the sum
            done <= 1;
        end
    end
endmodule