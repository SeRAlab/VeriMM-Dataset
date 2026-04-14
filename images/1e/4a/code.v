module ethernet_mac_controller (
    input wire clk,
    input wire rst,
    input wire [1519:0] frame_data,
    output reg valid_frame
);
    reg [15:0] frame_length;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            valid_frame <= 0;
        end else begin
            frame_length <= frame_data[15:0]; // Assume the first 16 bits indicate frame length
            if (frame_length >= 64 && frame_length <= 1518) begin
                valid_frame <= 1;
            end else begin
                valid_frame <= 0;
            end
        end
    end
endmodule