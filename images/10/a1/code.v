module sata_controller (
    input wire clk,
    input wire reset,
    input wire start,
    input wire transfer_done,
    output reg [1:0] state // 00: Idle, 01: Transfer, 10: Complete
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 2'b00; // Idle
        end else begin
            case (state)
                2'b00: begin // Idle
                    if (start) state <= 2'b01; // Go to Transfer
                end
                2'b01: begin // Transfer
                    if (transfer_done) state <= 2'b10; // Go to Complete
                end
                2'b10: begin // Complete
                    state <= 2'b00; // Return to Idle
                end
            endcase
        end
    end
endmodule