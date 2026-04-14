module dma_controller (
    input wire start,
    input wire [1:0] channel_select,
    input wire [15:0] mem_addr,
    input wire [31:0] data_in,
    input wire clk,
    input wire reset,
    output reg [31:0] data_out,
    output reg done,
    output reg [1:0] active_channel
);
    reg [1:0] state;
    localparam IDLE = 2'b00, ACTIVE = 2'b01, DONE = 2'b10;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            done <= 0;
            active_channel <= 2'b00;
            data_out <= 32'b0;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        active_channel <= channel_select;
                        data_out <= data_in;  // Simulate data being sent to memory
                        state <= ACTIVE;
                        done <= 0;
                    end
                end
                ACTIVE: begin
                    // Simulate transfer time
                    state <= DONE;
                end
                DONE: begin
                    done <= 1;
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule