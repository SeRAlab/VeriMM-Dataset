module ethernet_mac_controller(
    input clk,
    input reset,
    input [7:0] data_in,
    input data_valid,
    output reg frame_valid
);
    reg [7:0] buffer [0:15]; // Buffer for incoming data
    reg [3:0] count; // Counter for the buffer
    reg sfd_detected; // Flag to indicate SFD detection

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 0;
            frame_valid <= 0;
            sfd_detected <= 0;
        end else begin
            if (data_valid) begin
                if (count < 16) begin
                    buffer[count] <= data_in;
                    count <= count + 1;
                end
                // Check for SFD
                if (data_in == 8'hD5) begin
                    sfd_detected <= 1;
                end
            end
            
            // Set frame valid if SFD was detected
            if (sfd_detected) begin
                frame_valid <= 1;
            end else begin
                frame_valid <= 0;
            end
        end
    end
endmodule