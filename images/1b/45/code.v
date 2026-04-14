module packet_filter (
    input wire clk,
    input wire rst,
    input wire [31:0] src_ip,
    input wire [31:0] dst_ip,
    input wire [15:0] dst_port,
    output reg accept
);
    reg last_accepted;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            accept <= 0;
            last_accepted <= 0;
        end else begin
            if ((src_ip >= 32'hC0A80101) && (src_ip <= 32'hC0A8010A) && (dst_port == 16'd80)) begin
                accept <= 1;
                last_accepted <= 1;
            end else begin
                accept <= 0;
                last_accepted <= 0;
            end
        end
    end
endmodule