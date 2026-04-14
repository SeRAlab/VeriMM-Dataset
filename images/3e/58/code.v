module ofdm_modulator (
    input wire clk,
    input wire reset,
    input wire [7:0] input_bits,
    output reg [3:0] subcarrier_0,
    output reg [3:0] subcarrier_1,
    output reg [3:0] subcarrier_2,
    output reg [3:0] subcarrier_3,
    output reg valid
);

reg [2:0] state;
parameter IDLE = 3'b000, PROCESS = 3'b001, OUTPUT = 3'b010;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= IDLE;
        valid <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (input_bits) begin
                    state <= PROCESS;
                end
            end
            PROCESS: begin
                subcarrier_0 <= {input_bits[1:0], input_bits[7:6]};
                subcarrier_1 <= {input_bits[3:2], input_bits[5:4]};
                subcarrier_2 <= {input_bits[5:4], input_bits[3:2]};
                subcarrier_3 <= {input_bits[7:6], input_bits[1:0]};
                valid <= 1;
                state <= OUTPUT;
            end
            OUTPUT: begin
                valid <= 0;
                state <= IDLE;
            end
        endcase
    end
end

endmodule