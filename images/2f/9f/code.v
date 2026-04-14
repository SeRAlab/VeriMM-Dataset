module ofdm_modulator(
    input wire clk,
    input wire reset,
    input wire valid_in,
    input wire [1:0] bit_in, // 2-bit QPSK input
    output reg [15:0] subcarrier_out_real,
    output reg [15:0] subcarrier_out_imag,
    output reg valid_out
);
    reg [1:0] state;
    reg [3:0] count;
    
    parameter IDLE = 2'b00;
    parameter PROCESS = 2'b01;
    parameter OUTPUT = 2'b10;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            count <= 0;
            valid_out <= 0;
            subcarrier_out_real <= 0;
            subcarrier_out_imag <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (valid_in) begin
                        state <= PROCESS;
                        count <= 0;
                    end
                end
                PROCESS: begin
                    if (count < 2) begin
                        // Process incoming bits and prepare output
                        if (bit_in == 2'b00) begin
                            subcarrier_out_real <= 16'h1FFF; // Example values for QPSK
                            subcarrier_out_imag <= 16'h0; 
                        end else if (bit_in == 2'b01) begin
                            subcarrier_out_real <= 16'h0; 
                            subcarrier_out_imag <= 16'h1FFF; 
                        end else if (bit_in == 2'b10) begin
                            subcarrier_out_real <= -16'h1FFF; 
                            subcarrier_out_imag <= 16'h0; 
                        end else if (bit_in == 2'b11) begin
                            subcarrier_out_real <= 16'h0; 
                            subcarrier_out_imag <= -16'h1FFF; 
                        end
                        count <= count + 1;
                    end else begin
                        state <= OUTPUT;
                    end
                end
                OUTPUT: begin
                    valid_out <= 1;
                    state <= IDLE;  // Go back to IDLE after outputting
                end
            endcase
        end
    end
endmodule