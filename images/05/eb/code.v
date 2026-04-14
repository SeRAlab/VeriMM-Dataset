module dma_controller (
    input clk,
    input rst,
    input start,
    input [7:0] addr,
    input [2:0] chan_sel,
    output reg [7:0] data_out,
    output reg done,
    output reg read
);
    reg [2:0] state, next_state;
    reg [7:0] data_memory [0:7]; // Simulate memory for 8 channels

    localparam IDLE = 3'b000, READ = 3'b001, DONE = 3'b010;

    // Initialize data for each channel
    initial begin
        data_memory[0] = 8'hAA;
        data_memory[1] = 8'hBB;
        data_memory[2] = 8'hCC;
        data_memory[3] = 8'hDD;
        data_memory[4] = 8'hEE;
        data_memory[5] = 8'hFF;
        data_memory[6] = 8'h11;
        data_memory[7] = 8'h22;
    end

    // State transition
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            done <= 0;
            read <= 0;
        end else begin
            state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (start) begin
                    next_state = READ;
                    done = 0;
                end else begin
                    next_state = IDLE;
                end
            end
            READ: begin
                data_out = data_memory[chan_sel];
                read = 1;
                next_state = DONE;
            end
            DONE: begin
                done = 1;
                read = 0;
                next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end
endmodule