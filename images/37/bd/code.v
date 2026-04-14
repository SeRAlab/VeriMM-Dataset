module firewall (
    input [15:0] packet_address,
    input [3:0] protocol,
    output reg permit
);

always @(*) begin
    if ((packet_address >= 16'h0000 && packet_address <= 16'h7FFF) && 
        (protocol == 4'b0001 || protocol == 4'b0010)) begin
        permit = 1'b1; // Permit the packet
    end else begin
        permit = 1'b0; // Block the packet
    end
end

endmodule