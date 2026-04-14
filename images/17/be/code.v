module I2C_Controller(
    input wire clk,
    input wire start,
    input wire stop,
    input wire [7:0] data,
    output reg SDA,
    output reg SCL,
    output reg [1:0] state // 00: idle, 01: transmitting, 10: completed
);
    reg [3:0] bit_count; // to count the bits being transmitted
    reg [7:0] data_reg;

    // State encoding
    localparam IDLE = 2'b00;
    localparam TRANSMITTING = 2'b01;
    localparam COMPLETED = 2'b10;

    always @(posedge clk) begin
        case (state)
            IDLE: begin
                if (start) begin
                    state <= TRANSMITTING;
                    data_reg <= data;
                    bit_count <= 0;
                    SDA <= 0; // Start condition
                end
            end
            
            TRANSMITTING: begin
                if (bit_count < 8) begin
                    SCL <= 0; // Clock low
                    SDA <= data_reg[7-bit_count]; // Send the bit
                    bit_count <= bit_count + 1;
                    SCL <= 1; // Clock high
                end else begin
                    state <= COMPLETED; // All bits are sent
                end
            end
            
            COMPLETED: begin
                SDA <= 1; // Stop condition
                state <= IDLE; // Go back to idle
            end
            
            default: state <= IDLE;
        endcase
    end
endmodule