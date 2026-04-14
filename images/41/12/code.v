module top_module(
    input clk,
    input rst,
    input send,
    input [7:0] data,
    output reg txd
);localparam STATE1 = 2'b00;
localparam STATE2 = 2'b01;
localparam STATE3 = 2'b10;
localparam STATE4 = 2'b11;

reg [1:0] state = STATE1;
reg [7:0] tmp_data;
reg last_send_val = 1'b0;
reg [2:0] current_bit;
reg d = 1'b0;

always @(posedge clk) begin
    if (rst) begin
        d <= 0;
        state <= STATE1;
    end
    else begin
        case (state)
            STATE1: begin
                if (send == 1'b1 && last_send_val == 1'b0) begin
                    tmp_data <= data;
                    current_bit <= 3'b000;
                    state <= STATE2;
                end
            end
            STATE2: begin
                d <= 1'b1;
                state <= STATE3;
            end
            STATE3: begin
                d <= tmp_data[current_bit];
                current_bit <= current_bit + 1;
                if (current_bit == 3'b111) begin
                    state <= STATE4;
                end
            end
            STATE4: begin
                d <= 1'b0;
                state <= STATE1;
            end
            default: begin
                // do nothing
            end
        endcase
    end
    last_send_val <= send;
end

assign txd = d;

endmodule