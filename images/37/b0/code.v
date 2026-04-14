module dma_controller (
    input clk,
    input rst,
    input start_ch1,
    input start_ch2,
    input [15:0] src_addr_ch1,
    input [15:0] dest_addr_ch1,
    input [15:0] src_addr_ch2,
    input [15:0] dest_addr_ch2,
    output reg done_ch1,
    output reg done_ch2
);
    reg [1:0] state; // 00: idle, 01: transfer ch1, 10: transfer ch2
    reg [15:0] src_addr;
    reg [15:0] dest_addr;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= 2'b00;
            done_ch1 <= 0;
            done_ch2 <= 0;
        end else begin
            case (state)
                2'b00: begin // idle
                    done_ch1 <= 0;
                    done_ch2 <= 0;
                    if (start_ch1) begin
                        src_addr <= src_addr_ch1;
                        dest_addr <= dest_addr_ch1;
                        state <= 2'b01; // start transfer channel 1
                    end else if (start_ch2) begin
                        src_addr <= src_addr_ch2;
                        dest_addr <= dest_addr_ch2;
                        state <= 2'b10; // start transfer channel 2
                    end
                end
                2'b01: begin // transfer channel 1
                    // Simulate data transfer here (dummy operation)
                    done_ch1 <= 1; // Indicate done
                    state <= 2'b00; // go back to idle
                end
                2'b10: begin // transfer channel 2
                    // Simulate data transfer here (dummy operation)
                    done_ch2 <= 1; // Indicate done
                    state <= 2'b00; // go back to idle
                end
            endcase
        end
    end
endmodule