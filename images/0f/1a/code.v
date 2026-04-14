module ofdm_modulator (
    input wire clk,
    input wire rst,
    input wire [3:0] data_in,
    output reg [3:0] data_out,
    output reg valid
);
    reg [1:0] state; // State for the FSM
    parameter IDLE = 2'b00, MODULATE = 2'b01, OUTPUT = 2'b10;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            data_out <= 4'b0000;
            valid <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (data_in) begin
                        state <= MODULATE;
                    end
                end
                MODULATE: begin
                    // Simple binary to Gray code conversion
                    data_out <= data_in ^ (data_in >> 1);
                    state <= OUTPUT;
                end
                OUTPUT: begin
                    valid <= 1;
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule