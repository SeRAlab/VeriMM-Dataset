module packet_filter (
    input [7:0] S_IP,
    input [7:0] D_IP,
    input [15:0] P_TYPE,
    output reg [6:0] action // 'ALLOW' = 7'b0000001, 'DENY' = 7'b1111110
);

always @(*) begin
    if (S_IP == 8'hAA && D_IP == 8'h55 && (P_TYPE == 16'h0001 || P_TYPE == 16'h0002)) begin
        action = 7'b0000001; // ALLOW
    end else begin
        action = 7'b1111110; // DENY
    end
end

endmodule