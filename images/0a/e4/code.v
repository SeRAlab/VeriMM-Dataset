module nat_classifier(
    input wire isPublicIP,
    input wire isPortMapped,
    output reg [1:0] natType
);

always @(*) begin
    if (isPublicIP && isPortMapped)
        natType = 2'b00; // Open NAT
    else if (isPublicIP && !isPortMapped)
        natType = 2'b01; // Moderate NAT
    else if (!isPublicIP && isPortMapped)
        natType = 2'b10; // Strict NAT
    else
        natType = 2'b11; // Unclassified NAT
end

endmodule