module dma_controller (
    input wire clk,
    input wire reset,
    input wire request1,
    input wire request2,
    output reg grant,
    output reg busy,
    output reg [7:0] data
);

reg state; // 0 = idle, 1 = transferring
reg [7:0] mem [0:255]; // Memory array for data

always @(posedge clk or posedge reset) begin
    if (reset) begin
        grant <= 0;
        busy <= 0;
        state <= 0;
        data <= 0;
    end else begin
        case (state)
            0: begin // Idle state
                if (request1) begin
                    grant <= 1; // Grant channel 1
                    busy <= 1;
                    data <= mem[0]; // Example data transfer from memory
                    state <= 1; // Transition to transferring
                end else if (request2) begin
                    grant <= 0; // Grant channel 2
                    busy <= 1;
                    data <= mem[1]; // Example data transfer from memory
                    state <= 1; // Transition to transferring
                end
            end
            1: begin // Transferring state
                // Simulate the transfer delay
                busy <= 0;
                state <= 0; // Go back to idle
            end
        endcase
    end
end

endmodule