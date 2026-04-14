module top_module(
    input clock,
    input ready,
    input x,
    output reg y
);parameter DELAY_CYCLES = 10; // configurable delay period

reg [DELAY_CYCLES-1:0] delay_counter; // counter for delay period
reg prev_ready; // previous value of ready signal

always @(posedge clock) begin
    if (ready && !prev_ready) begin // ready signal just went high
        y <= x;
        delay_counter <= {DELAY_CYCLES{1'b0}}; // reset delay counter
    end else if (ready && x) begin // x signal is high
        y <= 1'b1;
        delay_counter <= delay_counter + 1;
    end else if (delay_counter == DELAY_CYCLES-1) begin // delay period is over
        y <= 1'b0;
        delay_counter <= {DELAY_CYCLES{1'b0}}; // reset delay counter
    end else if (!ready) begin // ready signal just went low
        y <= 1'b0;
        delay_counter <= {DELAY_CYCLES{1'b0}}; // reset delay counter
    end else begin // all other cases
        y <= 1'b0;
        delay_counter <= delay_counter + 1;
    end
    prev_ready <= ready; // store previous value of ready signal
end

endmodule