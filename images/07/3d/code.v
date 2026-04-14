module packet_filter (
    input wire clk,
    input wire rst,
    input wire [7:0] src_ip,
    input wire [7:0] dst_ip,
    input wire [7:0] allowed_src_ip,
    input wire [7:0] allowed_dst_ip,
    output reg allowed
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        allowed <= 0;
    end else begin
        if (src_ip == allowed_src_ip && dst_ip == allowed_dst_ip) begin
            allowed <= 1;
        end else begin
            allowed <= 0;
        end
    end
end

endmodule