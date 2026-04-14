module packet_filter (
    input clk,
    input reset,
    input [15:0] packet,
    input [3:0] rule,
    output reg accept
);

reg [3:0] rule_shift;
reg [2:0] packet_count;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        rule_shift <= 4'b0000;
        packet_count <= 3'b000;
        accept <= 0;
    end else begin
        rule_shift <= {rule_shift[2:0], rule}; // Shift the rules
        if (packet_count < 3'b100) begin
            packet_count <= packet_count + 1;
        end
        if (packet[15:12] == rule_shift) begin
            accept <= 1;
        end else begin
            accept <= 0;
        end
    end
end

endmodule