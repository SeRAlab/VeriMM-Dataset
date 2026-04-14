module dma_controller(
    input wire clk,
    input wire reset,
    input wire start,
    input wire [1:0] channel_select,
    input wire [7:0] data_in,
    output reg [7:0] data_out,
    output reg done
);
    reg [2:0] state;
    reg [7:0] channel_data [3:0]; // 4 channels of data storage

    localparam IDLE = 3'b000,
               TRANSFER = 3'b001,
               DONE = 3'b010;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            done <= 0;
            data_out <= 8'b0;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        state <= TRANSFER;
                        done <= 0;
                    end
                end
                TRANSFER: begin
                    channel_data[channel_select] <= data_in; // Store data in selected channel
                    data_out <= channel_data[channel_select]; // Output data from the selected channel
                    state <= DONE;
                end
                DONE: begin
                    done <= 1; // Indicate transfer done
                    state <= IDLE; // Go back to idle
                end
            endcase
        end
    end
endmodule