module state_machine (
    input wire clk,
    input wire reset,
    input wire start,
    output reg [1:0] state
);
    // State encoding
    parameter IDLE = 2'b00, PROCESS = 2'b01, DONE = 2'b10;
    reg [1:0] next_state;
    reg [2:0] count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            count <= 0;
        end else begin
            state <= next_state;
            if (state == PROCESS) begin
                count <= count + 1;
            end else begin
                count <= 0;
            end
        end
    end

    always @(*) begin
        case (state)
            IDLE: begin
                if (start) begin
                    next_state = PROCESS;
                end else begin
                    next_state = IDLE;
                end
            end
            PROCESS: begin
                if (count == 4) begin
                    next_state = DONE;
                end else begin
                    next_state = PROCESS;
                end
            end
            DONE: begin
                next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end
endmodule