module sliding_window_protocol #(parameter WINDOW_SIZE = 4, DATA_WIDTH = 8) (
    input clk,
    input reset,
    input send,
    input ack,
    input [DATA_WIDTH-1:0] data_in,
    output reg [DATA_WIDTH-1:0] data_out,
    output reg full,
    output reg empty
);
    reg [DATA_WIDTH-1:0] window [0:WINDOW_SIZE-1];
    reg [3:0] send_pointer, recv_pointer;
    reg [3:0] count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            send_pointer <= 0;
            recv_pointer <= 0;
            count <= 0;
            full <= 0;
            empty <= 1;
        end else begin
            if (send && !full) begin
                window[send_pointer] <= data_in;
                send_pointer <= (send_pointer + 1) % WINDOW_SIZE;
                count <= count + 1;
            end
            if (ack && !empty) begin
                data_out <= window[recv_pointer];
                recv_pointer <= (recv_pointer + 1) % WINDOW_SIZE;
                count <= count - 1;
            end
            full <= (count == WINDOW_SIZE);
            empty <= (count == 0);
        end
    end
endmodule