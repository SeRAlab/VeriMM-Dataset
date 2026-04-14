module top_module(
    // inputs:
    empty,
    ge2_free,
    ge3_free,
    input_tm_cnt,

    // outputs:
    fifo_cnt_inc
);output  [4:0] fifo_cnt_inc;
    input            empty;
    input            ge2_free;
    input            ge3_free;
    input   [1:0]    input_tm_cnt;

    reg     [4:0]    fifo_cnt_inc;

    always @(*) begin
        case ({empty, ge2_free, ge3_free, input_tm_cnt})
            {1'b1, 1'b0, 1'b0, 2'b00}: fifo_cnt_inc = 5'b00001;
            {1'b1, 1'b0, 1'b0, 2'b01}: fifo_cnt_inc = 5'b00010;
            {1'b1, 1'b0, 1'b0, 2'b10}: fifo_cnt_inc = 5'b00011;
            {1'b1, 1'b0, 1'b0, 2'b11}: fifo_cnt_inc = 5'b00011;
            {1'b0, 1'b0, 1'b0, 2'b00}: fifo_cnt_inc = 5'b00000;
            {1'b0, 1'b0, 1'b0, 2'b01}: fifo_cnt_inc = 5'b00000;
            {1'b0, 1'b0, 1'b0, 2'b10}: fifo_cnt_inc = 5'b00000;
            {1'b0, 1'b0, 1'b0, 2'b11}: fifo_cnt_inc = 5'b00000;
            {1'b0, 1'b0, 1'b1, 2'b11}: fifo_cnt_inc = 5'b00010;
            {1'b0, 1'b1, 1'b0, 2'b00}: fifo_cnt_inc = 5'b00000;
            {1'b0, 1'b1, 1'b0, 2'b01}: fifo_cnt_inc = 5'b00001;
            {1'b0, 1'b1, 1'b0, 2'b10}: fifo_cnt_inc = 5'b00001;
            {1'b0, 1'b1, 1'b0, 2'b11}: fifo_cnt_inc = 5'b00001;
            {1'b0, 1'b1, 1'b1, 2'b00}: fifo_cnt_inc = 5'b00000;
            {1'b0, 1'b1, 1'b1, 2'b01}: fifo_cnt_inc = 5'b00000;
            {1'b0, 1'b1, 1'b1, 2'b10}: fifo_cnt_inc = 5'b00000;
            {1'b0, 1'b1, 1'b1, 2'b11}: fifo_cnt_inc = 5'b00000;
            default: fifo_cnt_inc = 5'b11111;
        endcase
    end

endmodule