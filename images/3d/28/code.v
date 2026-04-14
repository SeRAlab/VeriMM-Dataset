module pcie_endpoint(
    input clk,
    input rst,
    input req_read,
    input req_write,
    input error,
    output reg [1:0] state // 00: IDLE, 01: READ, 10: WRITE, 11: ERROR
);

    // State Encoding
    parameter IDLE = 2'b00;
    parameter READ = 2'b01;
    parameter WRITE = 2'b10;
    parameter ERROR_STATE = 2'b11;

    // State Transition
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
        end else begin
            case(state)
                IDLE: begin
                    if (req_read) state <= READ;
                    else if (req_write) state <= WRITE;
                end
                READ: begin
                    if (error) state <= ERROR_STATE;
                    else state <= IDLE; // After reading, go back to IDLE
                end
                WRITE: begin
                    if (error) state <= ERROR_STATE;
                    else state <= IDLE; // After writing, go back to IDLE
                end
                ERROR_STATE: begin
                    state <= IDLE; // Reset to IDLE after error
                end
                default: state <= IDLE;
            endcase
        end
    end
endmodule