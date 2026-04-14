module top_module(
    input [3:0] BIN,
    output [3:0] BCD_HIGH,
    output [3:0] BCD_LOW
);wire [6:0] BCD;
    
    assign BCD = {
        (BIN >= 8) ? 1'b1 : 1'b0,
        (BIN >= 8 || BIN >= 4) ? 1'b1 : 1'b0,
        (BIN >= 8 || BIN >= 4 || BIN >= 2) ? 1'b1 : 1'b0,
        (BIN >= 8 || BIN >= 4 || BIN >= 2 || BIN >= 1) ? 1'b1 : 1'b0,
        (BIN >= 8 || BIN >= 2 || BIN >= 1) ? 1'b1 : 1'b0,
        (BIN >= 4 || BIN >= 2 || BIN >= 1) ? 1'b1 : 1'b0,
        (BIN >= 2 || BIN >= 1) ? 1'b1 : 1'b0
    };
    
    assign BCD_HIGH = BCD[6:3];
    assign BCD_LOW = BCD[3:0];

endmodule