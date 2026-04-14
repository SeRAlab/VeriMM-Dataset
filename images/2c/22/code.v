module sliding_window_transmitter (
    input clk,
    input reset,
    input [7:0] data_in,
    input ack,
    output reg [7:0] window_out,
    output reg [3:0] window_size
);
    parameter MAX_WINDOW_SIZE = 4;
    reg [3:0] head;
    reg [3:0] tail;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            head <= 0;
            tail <= 0;
            window_size <= 0;
            window_out <= 0;
        end else begin
            if (ack && window_size > 0) begin
                head <= head + 1;
                window_size <= window_size - 1;
            end
            
            if (window_size < MAX_WINDOW_SIZE) begin
                window_out <= data_in;
                tail <= tail + 1;
                window_size <= window_size + 1;
            end
        end
    end
endmodule