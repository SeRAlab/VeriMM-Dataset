module top_module(
    input clk,
    input start,
    input reset,
    input [3:0] din,
    output reg [6:0] dout,
    output reg done_tick
);reg [1:0] current_state, next_state;
    reg [3:0] n, next_n;
    reg [6:0] fn, next_fn;

    localparam IDLE = 2'b00, OP = 2'b01, DONE = 2'b10;

    always @(posedge clk, posedge reset) begin
        if (reset) begin
            current_state <= IDLE;
            n <= 0;
            fn <= 1;
        end else begin
            current_state <= next_state;
            n <= next_n;
            fn <= next_fn;
        end
    end

    always @* begin
        next_state = current_state;
        next_n = n;
        next_fn = fn;
        done_tick = 0;
        dout = 0;
        case (current_state)
            IDLE:
                begin
                    next_n = 0;
                    next_fn = 1;
                    if (start && (din == 0)) begin
                        next_state = DONE;
                    end else if (start) begin
                        next_state = OP;
                    end
                end
            OP:
                begin
                    next_n = n + 1;
                    next_fn = fn + 5;
                    if (n == din) begin
                        next_state = DONE;
                    end
                end
            DONE:
                begin
                    done_tick = 1;
                    dout = fn;
                    next_state = IDLE;
                end
        endcase
    end

endmodule