module packet_filter (
    input [15:0] packet_id,
    output reg allowed
);
    // Define the allowed packet IDs
    parameter ID_1 = 16'hA1B2;
    parameter ID_2 = 16'hC3D4;
    parameter ID_3 = 16'hE5F6;

    always @(*) begin
        if (packet_id == ID_1 || packet_id == ID_2 || packet_id == ID_3) begin
            allowed = 1'b1; // Packet is allowed
        end else begin
            allowed = 1'b0; // Packet is denied
        end
    end
endmodule