module top_module(
    input clk,
    input rst,
    input start,
    input stop,
    input reset,
    input load,
    input [31:0] value,
    output interrupt
);reg [31:0] counter;
    reg [31:0] load_value;
    reg [1:0] state;
    reg interrupt_reg;

    parameter IDLE = 2'b00;
    parameter RUNNING = 2'b01;
    parameter STOPPED = 2'b10;

    always @(posedge clk) begin
        if (rst) begin
            counter <= 0;
            state <= IDLE;
            interrupt_reg <= 0;
        end else begin
            case (state)
                IDLE: begin
                    counter <= value;
                    if (load) begin
                        load_value <= value;
                        state <= IDLE;
                    end else if (start) begin
                        state <= RUNNING;
                    end else begin
                        state <= IDLE;
                    end
                end
                RUNNING: begin
                    if (stop) begin
                        state <= STOPPED;
                    end else if (counter == 0) begin
                        interrupt_reg <= 1;
                        state <= IDLE;
                    end else begin
                        counter <= counter - 1;
                        state <= RUNNING;
                    end
                end
                STOPPED: begin
                    if (start) begin
                        state <= RUNNING;
                    end else if (reset) begin
                        counter <= 0;
                        state <= IDLE;
                    end else begin
                        state <= STOPPED;
                    end
                end
            endcase
        end
    end

    assign interrupt = interrupt_reg;

endmodule