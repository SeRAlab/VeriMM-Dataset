module dma_controller(
    input wire clk,
    input wire reset,
    input wire start,
    input wire channel_select, // 0 for channel 0, 1 for channel 1
    input wire [7:0] source_address,
    input wire [7:0] destination_address,
    input wire [7:0] data_in,
    output reg [7:0] data_out,
    output reg transfer_done
);
    reg [7:0] memory [0:255]; // Simple memory for data storage
    reg [1:0] state; // 0: idle, 1: transfer, 2: done

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 0;
            transfer_done <= 0;
            data_out <= 0;
        end else begin
            case (state)
                0: begin // idle
                    if (start) begin
                        state <= 1;
                        transfer_done <= 0;
                    end
                end
                1: begin // transfer
                    data_out <= data_in; // Transfer data
                    memory[destination_address] <= data_out; // Store data to memory
                    state <= 2; // Move to done state
                end
                2: begin // done
                    transfer_done <= 1; // Indicate transfer is complete
                    state <= 0; // Go back to idle
                end
            endcase
        end
    end
endmodule