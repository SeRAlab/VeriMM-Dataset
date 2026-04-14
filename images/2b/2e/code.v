module pcie_packet_detector (
    input wire clk,
    input wire rst_n,
    input wire [7:0] data_in,
    output reg packet_detected
);
    reg state;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            packet_detected <= 0;
            state <= 0;
        end else begin
            if (data_in == 8'hA5 && !state) begin
                packet_detected <= 1;
                state <= 1;
            end else begin
                packet_detected <= 0;
                state <= 0;
            end
        end
    end
endmodule