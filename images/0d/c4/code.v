module ethernet_mac_controller (
    input wire clk,
    input wire reset,
    input wire tx_buffer_empty,
    output reg tx_en
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        tx_en <= 0;
    end else begin
        if (~tx_buffer_empty) begin
            tx_en <= 1;
        end else begin
            tx_en <= 0;
        end
    end
end

endmodule