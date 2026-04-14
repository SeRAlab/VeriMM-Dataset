module ip_checksum (
    input [15:0] data_in,
    input valid,
    output reg [15:0] checksum,
    output reg ready
);
    reg [15:0] sum;
    
    always @(*) begin
        if (valid) begin
            sum = sum + data_in;
            if (sum[16]) begin
                sum = sum + 1; // Handle carry
            end
            checksum = ~sum; // One's complement
            ready = 1'b1;
        end else begin
            ready = 1'b0;
        end
    end

    initial begin
        sum = 16'b0;
    end
endmodule