module ip_checksum (
    input wire [15:0] data_in,
    input wire valid,
    input wire clk,
    input wire rst,
    output reg [15:0] checksum,
    output reg ready
);
    reg [15:0] sum;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            sum <= 16'h0000;
            checksum <= 16'h0000;
            ready <= 0;
        end else if (valid) begin
            sum <= sum + data_in;
            ready <= 0;
        end else begin
            checksum <= ~sum; // One's complement
            ready <= 1;
        end
    end
endmodule