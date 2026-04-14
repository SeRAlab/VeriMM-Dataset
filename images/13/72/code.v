module dma_controller(
    input wire clk,
    input wire reset,
    input wire start,
    input wire [7:0] src_address,
    input wire [7:0] dest_address,
    output reg done,
    output reg [7:0] data_out
);
    reg [7:0] memory [0:255]; // Simple memory array
    reg [7:0] src_data;
    reg [7:0] state;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            done <= 0;
            state <= 0;
        end else begin
            case (state)
                0: begin // Idle state
                    if (start) begin
                        src_data <= memory[src_address];
                        state <= 1; // Move to next state
                    end
                end
                1: begin // Transfer state
                    memory[dest_address] <= src_data; // Transfer data
                    done <= 1; // Signal done
                    state <= 0; // Go back to idle
                end
            endcase
        end
    end
endmodule