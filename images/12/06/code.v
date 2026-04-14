module packet_filter (
    input wire clk,
    input wire rst,
    input wire [31:0] packet,
    input wire [31:0] filter,
    output reg valid
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            valid <= 0;
        end else begin
            if ((packet & filter) == filter) begin
                valid <= 1; // Packet is valid
            end else begin
                valid <= 0; // Packet is invalid
            end
        end
    end
endmodule