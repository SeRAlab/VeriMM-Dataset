module ip_checksum (
    input [15:0] data_in,
    input clk,
    input compute,
    output reg [15:0] checksum
);
    reg [15:0] sum;
    
    always @(posedge clk) begin
        if (compute) begin
            sum <= sum + data_in;
        end
    end

    always @(posedge clk) begin
        if (compute) begin
            checksum <= ~sum; // One's complement
        end
    end
endmodule