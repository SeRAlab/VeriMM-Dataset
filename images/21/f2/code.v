module dma_controller (
    input clk,
    input rst,
    input req1,
    input req2,
    input [31:0] src_addr1,
    input [31:0] src_addr2,
    input [31:0] dest_addr1,
    input [31:0] dest_addr2,
    output reg active1,
    output reg active2,
    output reg [31:0] data1,
    output reg [31:0] data2,
    output reg transfer_done
);
    reg [3:0] state; // State for transfer
    parameter IDLE = 0, TRANSFER1 = 1, TRANSFER2 = 2, DONE = 3;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            active1 <= 0;
            active2 <= 0;
            transfer_done <= 0;
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (req1) begin
                        active1 <= 1;
                        data1 <= src_addr1; // Simulate data transfer
                        state <= TRANSFER1;
                    end else if (req2) begin
                        active2 <= 1;
                        data2 <= src_addr2; // Simulate data transfer
                        state <= TRANSFER2;
                    end
                end
                TRANSFER1: begin
                    // Simulate transfer time
                    if (active1) begin
                        data1 <= data1 + 1; // Increment data as a simple transfer simulation
                        state <= DONE;
                    end
                end
                TRANSFER2: begin
                    if (active2) begin
                        data2 <= data2 + 1; // Increment data as a simple transfer simulation
                        state <= DONE;
                    end
                end
                DONE: begin
                    active1 <= 0;
                    active2 <= 0;
                    transfer_done <= 1;
                    state <= IDLE; // Go back to idle
                end
            endcase
        end
    end
endmodule