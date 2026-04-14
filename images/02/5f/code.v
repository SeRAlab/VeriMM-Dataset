module ofdm_modulator (
    input wire clk,
    input wire reset,
    input wire [3:0] data_in,
    output reg [1:0] qpsk_out,
    output reg ready
);

    reg [1:0] phase;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            qpsk_out <= 2'b00;
            ready <= 0;
            phase <= 0;
        end else begin
            case (data_in)
                4'b0000: qpsk_out <= 2'b00; // 0° Phase
                4'b0001: qpsk_out <= 2'b01; // 90° Phase
                4'b0010: qpsk_out <= 2'b10; // 180° Phase
                4'b0011: qpsk_out <= 2'b11; // 270° Phase
                default: qpsk_out <= 2'b00; // Default case
            endcase
            ready <= 1;
        end
    end
endmodule