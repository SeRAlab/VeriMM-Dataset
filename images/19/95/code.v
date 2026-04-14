module sata_controller (
    input wire clk,
    input wire reset,
    input wire start_transfer,
    input wire error,
    output reg [1:0] state // 00: Idle, 01: Active, 10: Error
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 2'b00; // Idle
        end else begin
            case (state)
                2'b00: begin // Idle
                    if (start_transfer) begin
                        state <= 2'b01; // Active
                    end
                end
                2'b01: begin // Active
                    if (error) begin
                        state <= 2'b10; // Error
                    end
                end
                2'b10: begin // Error
                    if (!error) begin
                        state <= 2'b00; // Idle
                    end
                end
            endcase
        end
    end
endmodule