module packet_filter (
    input clk,
    input reset,
    input [15:0] packet_address,
    input [3:0] packet_protocol,
    output reg accepted
);

    // Define some example rules
    localparam ADDRESS_RULE = 16'hABCD; // Example address rule
    localparam PROTOCOL_RULE = 4'b1010; // Example protocol rule

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            accepted <= 0; // Reset the accepted output
        end else begin
            if (packet_address == ADDRESS_RULE && packet_protocol == PROTOCOL_RULE) begin
                accepted <= 1; // Accept the packet
            end else begin
                accepted <= 0; // Reject the packet
            end
        end
    end
endmodule