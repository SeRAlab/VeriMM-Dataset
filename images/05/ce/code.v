module dma_controller (
    input wire clk,
    input wire reset,
    input wire start,
    input wire [7:0] src_addr,
    input wire [7:0] dest_addr,
    output reg busy,
    output reg [7:0] data_out
);
    reg [1:0] state; // 0: idle, 1: transferring, 2: done
    reg [3:0] count; // to count number of words transferred
    reg [7:0] memory [255:0]; // Memory array for simulation

    // Initialize memory with some data
    initial begin
        // Example data initialization
        memory[0] = 8'hAA;
        memory[1] = 8'hBB;
        memory[2] = 8'hCC;
        memory[3] = 8'hDD;
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 0;
            busy <= 0;
            count <= 0;
            data_out <= 8'b0;
        end else begin
            case (state)
                0: begin // idle state
                    busy <= 0;
                    if (start) begin
                        busy <= 1;
                        count <= 0;
                        state <= 1; // move to transferring state
                    end
                end
                1: begin // transferring state
                    if (count < 4) begin
                        data_out <= memory[src_addr + count]; // transfer data
                        count <= count + 1;
                    end else begin
                        state <= 2; // transition to done state
                    end
                end
                2: begin // done state
                    busy <= 0;
                    state <= 0; // go back to idle
                end
            endcase
        end
    end
endmodule