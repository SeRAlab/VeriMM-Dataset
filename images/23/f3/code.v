module dma_controller (
    input wire [3:0] request,
    input wire clk,
    input wire reset,
    output reg [1:0] service_channel
);
    reg [1:0] current_channel;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            service_channel <= 2'b00;
            current_channel <= 2'b00;
        end else begin
            if (request != 4'b0000) begin
                // Check for the current channel and move to the next
                if (request[current_channel]) begin
                    service_channel <= current_channel;
                end
                
                // Move to the next channel in a round-robin fashion
                current_channel <= (current_channel + 1) % 4;
            end
        end
    end
endmodule