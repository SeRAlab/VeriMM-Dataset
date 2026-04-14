module packet_filter (
    input [7:0] packet_data,
    input valid,
    output reg accepted
);
    // Define filter rules (for example: accept packets with data equal to 8'hAA or 8'hBB)
    parameter FILTER1 = 8'hAA;
    parameter FILTER2 = 8'hBB;

    always @(*) begin
        if (valid) begin
            if (packet_data == FILTER1 || packet_data == FILTER2) begin
                accepted = 1'b1; // Packet accepted
            end else begin
                accepted = 1'b0; // Packet rejected
            end
        end else begin
            accepted = 1'b0; // If not valid, reject packet
        end
    end
endmodule