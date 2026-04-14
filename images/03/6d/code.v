module i2c_controller (
    input wire clk,
    input wire start,
    input wire [7:0] data,
    output reg SDA,
    output reg SCL
);
    reg [3:0] state;
    reg [7:0] shift_reg;
    parameter IDLE = 4'b0000, START_COND = 4'b0001, SEND_BYTE = 4'b0010, STOP_COND = 4'b0011;

    always @(posedge clk) begin
        case (state)
            IDLE: begin
                SDA <= 1'b1; // Idle state: SDA high
                SCL <= 1'b1; // Idle state: SCL high
                if (start) begin
                    state <= START_COND;
                end
            end

            START_COND: begin
                SDA <= 1'b0; // Start condition: SDA low
                SCL <= 1'b1;
                state <= SEND_BYTE;
                shift_reg <= data; // Load data to shift register
            end

            SEND_BYTE: begin
                if (shift_reg[7]) 
                    SDA <= 1'b1; // Send 1
                else 
                    SDA <= 1'b0; // Send 0
                SCL <= 1'b0; // Clock low
                #1 SCL <= 1'b1; // Clock high
                shift_reg <= shift_reg << 1; // Shift left
                if (shift_reg == 8'b00000000) begin
                    state <= STOP_COND;
                end
            end

            STOP_COND: begin
                SDA <= 1'b0; // SDA low
                SCL <= 1'b1; // SCL high
                #1 SDA <= 1'b1; // Stop condition: SDA goes high
                state <= IDLE; // Go back to idle
            end
        endcase
    end
endmodule