module NAT (
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
            case ({ip_in, port_in})
                {32'hC0A8010A, 16'h1F90}: begin // 192.168.1.10, 8080
                    ip_out <= 32'h0A000001; // 10.0.0.1
                    port_out <= 16'h2710; // 10000
                end
                {32'hC0A80114, 16'h1F91}: begin // 192.168.1.20, 8081
                    ip_out <= 32'h0A000002; // 10.0.0.2
                    port_out <= 16'h2711; // 10001
                end
                {32'hC0A8011E, 16'h1F92}: begin // 192.168.1.30, 8082
                    ip_out <= 32'h0A000003; // 10.0.0.3
                    port_out <= 16'h2712; // 10002
                end
                default: begin
                    ip_out <= ip_in;
                    port_out <= port_in;
                end
            endcase
        end
    end
endmodule