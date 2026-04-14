module i2c_controller (
    input wire clk,
    input wire reset,
    input wire start,
    input wire [7:0] data,
    input wire [6:0] address,
    output reg busy,
    output reg sda,
    output reg scl
);
    reg [3:0] state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;
    reg [6:0] addr_reg;

    localparam IDLE = 4'b0000,
               START = 4'b0001,
               ADDRESS = 4'b0010,
               DATA = 4'b0100,
               STOP = 4'b1000;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            busy <= 0;
            sda <= 1; // SDA idle high
            scl <= 0; // SCL idle low
            bit_count <= 0;
            shift_reg <= 0;
            addr_reg <= 0;
        end else begin
            case (state)
                IDLE: begin
                    busy <= 0;
                    if (start) begin
                        state <= START;
                        busy <= 1;
                        addr_reg <= address;
                        shift_reg <= data;
                        bit_count <= 7; // Start with MSB
                    end
                end
                START: begin
                    sda <= 0; // Start condition
                    state <= ADDRESS;
                end
                ADDRESS: begin
                    scl <= 1; // Clock high
                    sda <= addr_reg[bit_count]; // Send address bit
                    if (bit_count == 0) begin
                        state <= DATA;
                        bit_count <= 7; // Reset bit count for data
                    end else begin
                        bit_count <= bit_count - 1;
                    end
                end
                DATA: begin
                    scl <= 1; // Clock high
                    sda <= shift_reg[bit_count]; // Send data bit
                    if (bit_count == 0) begin
                        state <= STOP;
                    end else begin
                        bit_count <= bit_count - 1;
                    end
                end
                STOP: begin
                    sda <= 0; // Prepare stop condition
                    scl <= 1; // Clock high
                    sda <= 1; // Stop condition
                    state <= IDLE; // Back to idle
                end
            endcase
        end
    end
endmodule