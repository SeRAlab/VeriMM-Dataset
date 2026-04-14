module dma_controller (
    input wire clk,
    input wire rst,
    input wire req0,
    input wire req1,
    input wire req2,
    input wire req3,
    output reg grant,
    output reg done
);
    reg [1:0] state;
    reg [1:0] next_state;
    reg [1:0] current_channel;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= 2'b00; // IDLE state
            current_channel <= 2'b00;
            done <= 0;
        end else begin
            state <= next_state;
        end
    end

    always @(*) begin
        case (state)
            2'b00: begin // IDLE
                done = 0;
                if (req0) begin
                    grant = 1'b1; current_channel = 2'b00; next_state = 2'b01;
                end else if (req1) begin
                    grant = 1'b1; current_channel = 2'b01; next_state = 2'b01;
                end else if (req2) begin
                    grant = 1'b1; current_channel = 2'b10; next_state = 2'b01;
                end else if (req3) begin
                    grant = 1'b1; current_channel = 2'b11; next_state = 2'b01;
                end else begin
                    grant = 1'b0; next_state = 2'b00;
                end
            end
            2'b01: begin // ACTIVE
                grant = 1'b1;
                done = 1; // Transfer done
                next_state = 2'b00; // Go back to IDLE
            end
            default: begin
                grant = 1'b0;
                done = 0;
                next_state = 2'b00;
            end
        endcase
    end
endmodule