module top_module(
    input [3:0] data,
    input [1:0] sel,
    output y
);

    assign y = (sel == 2'b00) ? data[0] :
               (sel == 2'b01) ? data[1] :
               (sel == 2'b10) ? data[2] :
                                data[3];  // 4-to-1 MUX

endmodule