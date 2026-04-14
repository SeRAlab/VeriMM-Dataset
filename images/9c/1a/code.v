module sequence_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

parameter IDLE = 2'b00; // initial state
parameter S1 = 2'b01;  // detected '1'
parameter S10 = 2'b10; // detected '10'
parameter S101 = 2'b11; // detected '101'

reg [1:0] state, next_state;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        state <= IDLE;
    else
        state <= next_state;
end

always @(*) begin
    case (state)
        IDLE: begin
            if (data_in == 1)
                next_state = S1;
            else
                next_state = IDLE;
        end
        S1: begin
            if (data_in == 0)
                next_state = S10;
            else
                next_state = S1;
        end
        S10: begin
            if (data_in == 1)
                next_state = S101;
            else
                next_state = IDLE;
        end
        S101: begin
            next_state = IDLE;
        end
        default: next_state = IDLE;
    endcase
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        data_out <= 0;
    else if (state == S10 && data_in == 1)
        data_out <= 1;
    else
        data_out <= 0;
end

endmodule