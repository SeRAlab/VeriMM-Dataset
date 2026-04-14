module top_module(
    input [2:0] BIN,
    output [2:0] GRAY
);assign GRAY[0] = BIN[0] ^ BIN[1];
    assign GRAY[1] = BIN[1] ^ BIN[2];
    assign GRAY[2] = BIN[2];
    
endmodule