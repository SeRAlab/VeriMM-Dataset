module dma_controller(
    input clk,
    input rst,
    input start,
    input [7:0] src_addr0,
    input [7:0] src_addr1,
    input [7:0] dest_addr0,
    input [7:0] dest_addr1,
    input enable0,
    input enable1,
    output reg done
);

    reg [1:0] state; // 0: idle, 1: transfer channel 0, 2: transfer channel 1
    reg [7:0] src_addr;
    reg [7:0] dest_addr;

    parameter IDLE = 0, TRANSFER0 = 1, TRANSFER1 = 2;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            done <= 0;
        end else begin
            case (state)
                IDLE: begin
                    done <= 0;
                    if (start && (enable0 || enable1)) begin
                        if (enable0) begin
                            src_addr <= src_addr0;
                            dest_addr <= dest_addr0;
                            state <= TRANSFER0;
                        end else if (enable1) begin
                            src_addr <= src_addr1;
                            dest_addr <= dest_addr1;
                            state <= TRANSFER1;
                        end
                    end
                end
                TRANSFER0: begin
                    // Here we would normally perform the data transfer
                    // For this example, we simulate it with a done signal
                    done <= 1; // Simulate done
                    state <= IDLE; // Go back to idle
                end
                TRANSFER1: begin
                    // Here we would normally perform the data transfer
                    // For this example, we simulate it with a done signal
                    done <= 1; // Simulate done
                    state <= IDLE; // Go back to idle
                end
            endcase
        end
    end
endmodule