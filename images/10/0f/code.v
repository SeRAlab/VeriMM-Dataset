module wifi_module (
    input wire clk,
    input wire rst,
    input wire connect_req,
    output reg connection_state
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        connection_state <= 0; // Initialize to disconnected state
    end else begin
        if (connect_req) begin
            connection_state <= 1; // Change to connected state
        end
        // If connect_req is not asserted, the state remains unchanged
    end
end

endmodule