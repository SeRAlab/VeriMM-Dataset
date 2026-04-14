module pcie_endpoint_controller (
    input clk,
    input rst_n,
    input read_req,
    input [4:0] addr,
    output reg [7:0] data_out,
    output reg data_ready
);

    reg [1:0] state, next_state;
    parameter IDLE = 2'b00, READ_REQUEST = 2'b01, DATA_READY = 2'b10;

    // Memory array, for simplicity, let's assume 32 bytes.
    reg [7:0] memory [0:31];

    // Initializing memory with some values
    initial begin
        memory[0] = 8'hAA;
        memory[1] = 8'hBB;
        memory[2] = 8'hCC;
        memory[3] = 8'hDD;
        memory[4] = 8'hEE;
        // Fill in with more test values as needed
        memory[5] = 8'hFF;
        // More values can be added up to 32
    end

    // State transition
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (read_req)
                    next_state = READ_REQUEST;
                else
                    next_state = IDLE;
            end
            READ_REQUEST: begin
                next_state = DATA_READY;
            end
            DATA_READY: begin
                next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

    // Output logic
    always @(posedge clk) begin
        case (state)
            READ_REQUEST: begin
                data_out <= memory[addr];
                data_ready <= 0; // Prepare to output data
            end
            DATA_READY: begin
                data_ready <= 1; // Data is ready to be sent
            end
            default: begin
                data_ready <= 0; // Default to not ready
            end
        endcase
    end
endmodule