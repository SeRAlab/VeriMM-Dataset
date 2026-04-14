module mac_address_filter (
    input wire clk,
    input wire rst_n,
    input wire enable,
    input wire [47:0] incoming_mac,
    input wire [47:0] stored_mac,
    output reg traffic_allowed
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        traffic_allowed <= 0;
    end else if (enable) begin
        if (incoming_mac == stored_mac) begin
            traffic_allowed <= 1;
        end else begin
            traffic_allowed <= 0;
        end
    end
end

endmodule