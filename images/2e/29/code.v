module ethernet_mac_controller (
    input wire clk,
    input wire reset,
    input wire [7:0] frame_data,
    input wire [3:0] frame_length,
    input wire transmit_req,
    output reg tx_complete
);
    reg [7:0] frame_memory [0:15]; // Store up to 16 bytes of frame data
    reg [3:0] current_length;
    reg [3:0] current_index;
    reg transmitting;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_length <= 0;
            current_index <= 0;
            transmitting <= 0;
            tx_complete <= 0;
        end else begin
            if (transmit_req && !transmitting) begin
                current_length <= frame_length;
                current_index <= 0;
                transmitting <= 1;
                tx_complete <= 0;
            end else if (transmitting) begin
                if (current_index < current_length) begin
                    frame_memory[current_index] <= frame_data; // Store frame data
                    current_index <= current_index + 1;
                end else if (current_index == current_length) begin
                    transmitting <= 0;
                    tx_complete <= 1; // Transmission complete
                end
            end else begin
                tx_complete <= 0; // Reset the complete signal if not transmitting
            end
        end
    end
endmodule