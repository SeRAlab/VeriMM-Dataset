module sd_card_controller (
    input wire clk,
    input wire enable,
    input wire [7:0] data_in,
    input wire mode,  // 0 for read, 1 for write
    output reg [7:0] data_out,
    output reg busy
);
    reg [1:0] state;
    parameter IDLE = 2'b00, READ = 2'b01, WRITE = 2'b10;

    always @(posedge clk) begin
        if (enable) begin
            busy <= 1;
            case (state)
                IDLE: begin
                    if (mode) begin
                        state <= WRITE;
                        data_out <= data_in; // prepare data for write
                    end else begin
                        state <= READ;
                    end
                end
                READ: begin
                    // Simulate reading data
                    data_out <= 8'b10101010; // Example data read from SD card
                    state <= IDLE; // Go back to IDLE
                end
                WRITE: begin
                    // Simulate writing data
                    // In a real implementation, we would store data_in appropriately
                    state <= IDLE; // Go back to IDLE after write
                end
            endcase
        end else begin
            busy <= 0;
            state <= IDLE; // Reset state
        end
    end
endmodule