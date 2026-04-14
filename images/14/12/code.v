module NAT (
    input clk,
    input rst,
    input [1:0] op_mode, // 00: map, 01: unmap, 10: pass
    input [31:0] internal_ip,
    input [15:0] internal_port,
    input [31:0] external_ip,
    input [15:0] external_port,
    output reg [31:0] out_ip,
    output reg [15:0] out_port,
    output reg valid
);
    reg [31:0] mapped_ip;
    reg [15:0] mapped_port;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            valid <= 0;
            out_ip <= 0;
            out_port <= 0;
            mapped_ip <= 0;
            mapped_port <= 0;
        end else begin
            case (op_mode)
                2'b00: begin // map
                    mapped_ip <= external_ip;
                    mapped_port <= external_port;
                    valid <= 1;
                end
                2'b01: begin // unmap
                    if (mapped_ip == external_ip && mapped_port == external_port) begin
                        valid <= 0;
                    end else begin
                        valid <= 1; // Still valid as it could map to other IPs
                    end
                end
                2'b10: begin // pass
                    out_ip <= internal_ip;
                    out_port <= internal_port;
                    valid <= 1;
                end
            endcase
            if (valid) begin
                out_ip <= mapped_ip;
                out_port <= mapped_port;
            end
        end
    end
endmodule