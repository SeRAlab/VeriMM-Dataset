module dma_controller (
    input clk,
    input rst,
    input [1:0] enable, // 2-bit enable for channel 0 and channel 1
    input start,        // Start transfer signal
    input [7:0] src0,   // Source address for channel 0
    input [7:0] dst0,   // Destination address for channel 0
    input [7:0] src1,   // Source address for channel 1
    input [7:0] dst1,   // Destination address for channel 1
    output reg busy,    // Busy signal
    output reg [7:0] current_src, // Current source address
    output reg [7:0] current_dst  // Current destination address
);
    
    reg [1:0] state; // 00: idle, 01: transfer channel 0, 10: transfer channel 1
    parameter IDLE = 2'b00, TRANSFER0 = 2'b01, TRANSFER1 = 2'b10;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            busy <= 0;
            current_src <= 8'b0;
            current_dst <= 8'b0;
        end else begin
            case (state)
                IDLE: begin
                    busy <= 0;
                    if (enable[0] && start) begin
                        current_src <= src0;
                        current_dst <= dst0;
                        state <= TRANSFER0;
                    end else if (enable[1] && start) begin
                        current_src <= src1;
                        current_dst <= dst1;
                        state <= TRANSFER1;
                    end
                end
                TRANSFER0: begin
                    busy <= 1;
                    // Logic to transfer data from current_src to current_dst
                    // For the purpose of this example, we will just go back to idle
                    state <= IDLE;
                end
                TRANSFER1: begin
                    busy <= 1;
                    // Logic to transfer data from current_src to current_dst
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule