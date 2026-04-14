module spi_controller (
    input wire clk,
    input wire reset,
    input wire enable,
    input wire mosi,
    output wire miso,
    output reg [7:0] data_out,
    input wire [7:0] data_in
);
    
    reg [2:0] state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;

    localparam IDLE = 3'b000,
               RECEIVE = 3'b001,
               TRANSMIT = 3'b010;

    assign miso = shift_reg[7];

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'b000;
            data_out <= 8'b0;
            shift_reg <= 8'b0;
        end else if (enable) begin
            case (state)
                IDLE: begin
                    if (enable) begin
                        shift_reg <= data_in;  // Load data for transmission
                        state <= TRANSMIT;
                        bit_count <= 3'b000;  // Reset bit counter
                    end
                end
                TRANSMIT: begin
                    if (bit_count < 8) begin
                        shift_reg <= {shift_reg[6:0], mosi};  // Shift in MOSI data
                        data_out <= {data_out[6:0], miso};    // Shift out MISO data
                        bit_count <= bit_count + 1;
                    end else begin
                        state <= IDLE;  // Return to IDLE state after transmission
                    end
                end
            endcase
        end
    end
endmodule