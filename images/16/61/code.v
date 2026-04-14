module dma_controller (
    input wire clk,
    input wire reset,
    input wire [3:0] request, // 4 request lines for channels
    output reg [3:0] grant    // 4 grant lines for channels
);

reg [1:0] current_channel; // to keep track of the current channel that is granted

always @(posedge clk or posedge reset) begin
    if (reset) begin
        grant <= 4'b0000;
        current_channel <= 2'b00;
    end else begin
        grant <= 4'b0000; // Reset grants
        if (request != 4'b0000) begin // If there's any request
            // Grant access based on round-robin
            case (current_channel)
                2'b00: if (request[0]) begin grant[0] <= 1; current_channel <= 2'b00; end
                        else if (request[1]) begin grant[1] <= 1; current_channel <= 2'b01; end
                        else if (request[2]) begin grant[2] <= 1; current_channel <= 2'b10; end
                        else if (request[3]) begin grant[3] <= 1; current_channel <= 2'b11; end
                2'b01: if (request[1]) begin grant[1] <= 1; current_channel <= 2'b01; end
                        else if (request[2]) begin grant[2] <= 1; current_channel <= 2'b10; end
                        else if (request[3]) begin grant[3] <= 1; current_channel <= 2'b11; end
                        else if (request[0]) begin grant[0] <= 1; current_channel <= 2'b00; end
                2'b10: if (request[2]) begin grant[2] <= 1; current_channel <= 2'b10; end
                        else if (request[3]) begin grant[3] <= 1; current_channel <= 2'b11; end
                        else if (request[0]) begin grant[0] <= 1; current_channel <= 2'b00; end
                        else if (request[1]) begin grant[1] <= 1; current_channel <= 2'b01; end
                2'b11: if (request[3]) begin grant[3] <= 1; current_channel <= 2'b11; end
                        else if (request[0]) begin grant[0] <= 1; current_channel <= 2'b00; end
                        else if (request[1]) begin grant[1] <= 1; current_channel <= 2'b01; end
                        else if (request[2]) begin grant[2] <= 1; current_channel <= 2'b10; end
                default: current_channel <= 2'b00; // default case
            endcase
        end
    end
end

endmodule