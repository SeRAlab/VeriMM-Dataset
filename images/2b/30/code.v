module ip_checksum (
    input [15:0] data_in,
    input valid, // signal to indicate valid data
    input clk,   // clock signal for processing
    output reg [15:0] checksum,
    output reg valid_checksum // signal to indicate valid checksum output
);
    reg [15:0] sum;
    
    always @(posedge clk) begin
        if (valid) begin
            sum = sum + data_in; // accumulate sum of 16-bit words
        end
    end

    always @(posedge clk) begin
        if (valid) begin
            checksum = ~sum; // 1's complement
            valid_checksum = 1; // indicate valid checksum
        end else begin
            valid_checksum = 0; // not valid if no valid data
        end
    end
endmodule