module packet_filter (
    input [31:0] src_ip,
    input [15:0] dest_port,
    output reg permit
);
    always @(*) begin
        if (src_ip == 32'hC0A80101) begin // 192.168.1.1
            permit = 1'b1;
        end
        else if (src_ip == 32'h0A000001 && dest_port == 16'd80) begin // 10.0.0.1 to port 80
            permit = 1'b0;
        end
        else begin
            permit = 1'b1;
        end
    end
endmodule