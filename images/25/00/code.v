module ip_checksum (
    input [15:0] data,
    input enable,
    output reg [15:0] checksum
);
    always @(*) begin
        if (enable) begin
            checksum = ~data + 1; // Simple one's complement checksum
        end else begin
            checksum = 16'b0; // Zero when not enabled
        end
    end
endmodule