module ethernet_mac_controller(
    input wire clk,
    input wire reset,
    input wire start,
    input wire [7:0] data,
    output reg frame_valid
);

parameter TRANSMIT_TIME = 5; // Number of clock cycles to transmit

reg [2:0] count; // Counter to track transmission time
reg transmitting; // State of transmission

always @(posedge clk or posedge reset) begin
    if (reset) begin
        frame_valid <= 0;
        count <= 0;
        transmitting <= 0;
    end else begin
        if (start && !transmitting) begin
            transmitting <= 1;
            frame_valid <= 1;
            count <= 0;
        end else if (transmitting) begin
            if (count < TRANSMIT_TIME - 1) begin
                count <= count + 1;
            end else begin
                frame_valid <= 0;
                transmitting <= 0;
            end
        end
    end
end

endmodule