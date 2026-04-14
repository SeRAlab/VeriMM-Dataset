module top_module(
    input signal,
    output reg debounced_signal
);parameter debounce_time = 10;
parameter threshold = 5;

reg [1:0] state;
reg [debounce_time-1:0] counter;

always @(posedge signal) begin
    case(state)
        2'b00: begin
            counter <= debounce_time-1;
            state <= 2'b01;
        end
        2'b01: begin
            if(counter == 0) begin
                debounced_signal <= 1;
                counter <= debounce_time-1;
                state <= 2'b10;
            end else begin
                counter <= counter - 1;
            end
        end
        2'b10: begin
            if(signal == 0) begin
                state <= 2'b00;
            end
        end
    endcase
end

always @(posedge debounced_signal) begin
    debounced_signal <= 0;
end

endmodule