module NAT (
    input wire clk,
    input wire rst,
    input wire [31:0] src_ip,
    input wire [31:0] dest_ip,
    output reg [31:0] translated_src_ip
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        translated_src_ip <= 32'b0;
    end else begin
        if ((src_ip >= 32'hC0A80000) && (src_ip <= 32'hC0A8FFFF)) begin // 192.168.0.0/16
            translated_src_ip <= 32'hCB007101; // 203.0.113.1
        end else begin
            translated_src_ip <= src_ip; // No translation needed
        end
    end
end

endmodule