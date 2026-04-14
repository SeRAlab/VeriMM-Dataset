module top_module(clk, k_next, rx_state, rx_t1_part, rx_w1, 
                        tx_state, tx_t1_part);input clk;
    input [31:0] k_next;
    input [255:0] rx_state;
    input [31:0] rx_t1_part;
    input [31:0] rx_w1;

    output reg [255:0] tx_state;
    output reg [31:0] tx_t1_part;

    wire [31:0] e0_w, e1_w, ch_w, maj_w;

    // Define IDX macro
    `define IDX(x) (x * 32)

    // e0 block
    // takes two 32-bit inputs and outputs a 32-bit value
    // implementation not provided
    // usage: e0 e0_blk(rx_state[`IDX(0)], e0_w);
    
    // e1 block
    // takes two 32-bit inputs and outputs a 32-bit value
    // implementation not provided
    // usage: e1 e1_blk(rx_state[`IDX(4)], e1_w);
    
    // ch block
    // takes three 32-bit inputs and outputs a 32-bit value
    // implementation not provided
    // usage: ch ch_blk(rx_state[`IDX(4)], rx_state[`IDX(5)], rx_state[`IDX(6)], ch_w);
    
    // maj block
    // takes three 32-bit inputs and outputs a 32-bit value
    // implementation not provided
    // usage: maj maj_blk(rx_state[`IDX(0)], rx_state[`IDX(1)], rx_state[`IDX(2)], maj_w);

    wire [31:0] t1 = rx_t1_part + e1_w + ch_w ;
    wire [31:0] t2 = e0_w + maj_w;

    always @ (posedge clk)
    begin
        tx_t1_part <= (rx_state[`IDX(6)] + rx_w1 + k_next);
    
        tx_state[`IDX(7)] <= rx_state[`IDX(6)];
        tx_state[`IDX(6)] <= rx_state[`IDX(5)];
        tx_state[`IDX(5)] <= rx_state[`IDX(4)];
        tx_state[`IDX(4)] <= rx_state[`IDX(3)] + t1;
        tx_state[`IDX(3)] <= rx_state[`IDX(2)];
        tx_state[`IDX(2)] <= rx_state[`IDX(1)];
        tx_state[`IDX(1)] <= rx_state[`IDX(0)];
        tx_state[`IDX(0)] <= t1 + t2;
    end

endmodule