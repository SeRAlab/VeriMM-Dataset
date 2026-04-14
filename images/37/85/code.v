module I2C_Controller (
    input wire clk,
    input wire enable,
    input wire [7:0] data,
    output reg SDA,
    output reg SCL
);

    reg [3:0] state;
    reg [7:0] shift_reg;
    reg [2:0] bit_count;

    localparam IDLE = 4'd0,
               START = 4'd1,
               SEND = 4'd2,
               STOP = 4'd3;

    always @(posedge clk) begin
        if (enable) begin
            case (state)
                IDLE: begin
                    SDA <= 1; // Idle state of SDA
                    SCL <= 1; // Idle state of SCL
                    state <= START;
                end
                START: begin
                    SDA <= 0; // Start condition
                    SCL <= 1;
                    state <= SEND;
                    shift_reg <= data; // Load data to shift register
                    bit_count <= 7; // Prepare to send 8 bits
                end
                SEND: begin
                    SCL <= 0; // Clock low
                    SDA <= shift_reg[bit_count]; // Send bit
                    SCL <= 1; // Clock high
                    if (bit_count == 0)
                        state <= STOP;
                    else
                        bit_count <= bit_count - 1;
                end
                STOP: begin
                    SDA <= 0; // Prepare for stop condition
                    SCL <= 1; // Ensure SCL is high
                    SDA <= 1; // Stop condition
                    state <= IDLE; // Go back to idle
                end
            endcase
        end
    end
endmodule