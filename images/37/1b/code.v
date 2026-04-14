module sata_controller (
    input clk,
    input reset,
    input start,
    input error,
    output reg [1:0] state // 00: IDLE, 01: ACTIVE, 10: ERROR
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 2'b00; // IDLE
        end else begin
            case (state)
                2'b00: begin // IDLE
                    if (start) begin
                        state <= 2'b01; // ACTIVE
                    end
                end
                2'b01: begin // ACTIVE
                    if (error) begin
                        state <= 2'b10; // ERROR
                    end else if (!start) begin
                        state <= 2'b00; // IDLE
                    end
                end
                2'b10: begin // ERROR
                    if (reset) begin
                        state <= 2'b00; // IDLE
                    end
                end
            endcase
        end
    end
endmodule