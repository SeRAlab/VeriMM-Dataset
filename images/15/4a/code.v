module dma_controller(
    input wire clk,
    input wire reset,
    input wire start_ch1,
    input wire start_ch2,
    input wire [7:0] addr_ch1,
    input wire [7:0] addr_ch2,
    output reg done_ch1,
    output reg done_ch2
);
    reg [1:0] state_ch1;
    reg [1:0] state_ch2;

    parameter IDLE = 2'b00, TRANSFER = 2'b01, COMPLETE = 2'b10;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state_ch1 <= IDLE;
            state_ch2 <= IDLE;
            done_ch1 <= 0;
            done_ch2 <= 0;
        end else begin
            // Channel 1 Logic
            case (state_ch1)
                IDLE: begin
                    if (start_ch1) begin
                        state_ch1 <= TRANSFER;
                        done_ch1 <= 0;
                    end
                end
                TRANSFER: begin
                    state_ch1 <= COMPLETE;
                end
                COMPLETE: begin
                    done_ch1 <= 1;
                    state_ch1 <= IDLE; // Go back to idle after done
                end
            endcase
            
            // Channel 2 Logic
            case (state_ch2)
                IDLE: begin
                    if (start_ch2) begin
                        state_ch2 <= TRANSFER;
                        done_ch2 <= 0;
                    end
                end
                TRANSFER: begin
                    state_ch2 <= COMPLETE;
                end
                COMPLETE: begin
                    done_ch2 <= 1;
                    state_ch2 <= IDLE; // Go back to idle after done
                end
            endcase
        end
    end
endmodule