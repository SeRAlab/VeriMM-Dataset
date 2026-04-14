module ofdm_modulator #(parameter N = 64) (
    input wire clk,
    input wire rst,
    input wire valid_in,
    input wire [N-1:0] data_in,
    output reg valid_out,
    output reg [N-1:0] modulated_signal
);

reg [3:0] state;
localparam IDLE = 4'b0000, PROCESS = 4'b0001, OUTPUT = 4'b0010;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= IDLE;
        valid_out <= 0;
        modulated_signal <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (valid_in) begin
                    state <= PROCESS;
                end
            end
            PROCESS: begin
                // Simple IFFT operation simulation (in a real case, you'd call an IFFT function)
                modulated_signal <= data_in; // Placeholder for actual IFFT
                state <= OUTPUT;
            end
            OUTPUT: begin
                valid_out <= 1;
                state <= IDLE;
            end
        endcase
    end
end

endmodule