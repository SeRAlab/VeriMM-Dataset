module ip_checksum (
    input [15:0] data_in,
    input valid,
    input done,
    output reg [15:0] checksum,
    output reg ready
);
    reg [15:0] sum;
    initial begin
        sum = 16'h0000;
        checksum = 16'h0000;
        ready = 0;
    end
    
    always @(posedge valid) begin
        sum = sum + data_in;
    end
    
    always @(posedge done) begin
        checksum = ~sum; // One's complement
        ready = 1;
    end
endmodule