module spi_master (
    input clk,
    input rst,
    input mosi,
    input start,
    input [7:0] data_in,
    output reg sclk,
    output reg ss,
    output reg [7:0] data_out
);
    
    reg [3:0] bit_cnt;
    reg [7:0] shift_reg;
    reg state; // 0: idle, 1: sending
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            sclk <= 0;
            ss <= 1;
            bit_cnt <= 0;
            shift_reg <= 0;
            data_out <= 0;
            state <= 0;
        end else begin
            case (state)
                0: begin // Idle State
                    ss <= 1;
                    if (start) begin
                        ss <= 0; // Enable slave
                        shift_reg <= data_in; // Load data
                        bit_cnt <= 0;
                        state <= 1; // Move to sending state
                    end
                end
                1: begin // Sending State
                    sclk <= ~sclk; // Generate clock
                    if (sclk) begin // On rising edge
                        data_out[bit_cnt] <= mosi; // Read data
                        shift_reg <= {shift_reg[6:0], 1'b0}; // Shift left
                        bit_cnt <= bit_cnt + 1;
                        if (bit_cnt == 7) begin
                            state <= 0; // Go back to idle
                        end
                    end
                end
            endcase
        end
    end
    
endmodule