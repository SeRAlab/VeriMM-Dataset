module nat_translation (
    input wire clk,
    input wire reset,
    input wire [31:0] ip_in,
    input wire [15:0] port_in,
    output reg [31:0] ip_out,
    output reg [15:0] port_out
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            ip_out <= 32'b0;
            port_out <= 16'b0;
        end else begin
            if (ip_in == 32'hC0A80101) begin // 192.168.1.1 in hex
                ip_out <= 32'hCB007101; // 203.0.113.1 in hex
            end else begin
                ip_out <= ip_in;
            end
            port_out <= port_in + 1;
        end
    end
endmodule